Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792502452;
	b=Nb+paSqqDSkFfrWsSyiPokB8zrUBCPBDym/jASbiJ+go8B4mkwLi5OCHuOf20R/FwXAF
	 AvHpchSvDaAEwcEMN/zf5Xu1YDD5/ot1yKV32RpgXYK2kTmO5dxOctYPzxH9Wzdq0/t/B
	 pf9LQpPVPf3UoGWvkgIfpamvFvQnzik3OEnz3iUeLQ4njPwrApv765MjXaa3aB9PA0uwh
	 zulGU7WJrzI4nonIu/FcGUJtFmQIewm6C0+VGx87eirHNZM0Kyt5BvUKuyFxsfxaJYUh0
	 isHH7/DCTHbw/YfNTt3kzZKjhlmH8r1U6MAXeh07EiKUGJnMMs/49xUXayiYY7q74Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502452;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=1aDjPA8RRZSC5RYtmkxavzjaFEuPSiecALjC0nZN+Aw=;
	b=SdRGMha98TKZfIor+Ytq0vsPww0TbAqgm0FXb93SEw5igtuXHyNXJaKHu6jL47RxwzT4
	 2a9HAkd4l/zhgqjaMTH+XC4n6sXMORu7pzWes21YlZEj9ibG184Z3tB5SP0rdUIDxHDDe
	 4DIuq2tJQ5lM16GgweAjELFoXmJCAMZsFc5EWrmdEg1uAISoqkA3x/tLp9e+V9AZGNetc
	 oKlVb/sc1GgTh4NNn8KAFQbWTlDAROVyitIAB4EvNL1WxtXgDQ091yAPjHdLvqj4Yc2Cp
	 NWv/Re7s3ukR5YoUA59YKhHbpb64ZP22anZ5G5VtYYjJmXqyzUZUriKZTLw8gP3SR0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rcwmCASu;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BDF606A31B
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 13:20:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3BDF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rcwmCASu
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a070b3f44aso668369b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 06:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792502451; x=1793107251; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1aDjPA8RRZSC5RYtmkxavzjaFEuPSiecALjC0nZN+Aw=;
        b=rcwmCASuLgxsbEPoDfm/Ukh0cXl0rSSVME+BUp10XnjMBdJVdNVCtwU5mcYvOEFGEw
         KJ+cPp9W8g2LCGh7UAFHAdbD1bL+Yv0PT2xDja4cF4vIaU4uJIWfA5rJojhsZrTurdI0
         bFaROH4CPUUbzDBV5Ak39vvvXhJhDa5UWSx+hl9iUTVMJWbHafdvJjiuFBlQpziQSMj8
         FaCC5V/D3shcxw15FLRDY9FXDHVXkr86HaLFtDwfnBbUdgc8Yh9PKLvArVg1c2NoEYZS
         VBou7r0GqJPNcGgKjMExQ86x7x/Np1eOQ+Va9kSFrRblfyG0J7pGJxX/mZpcmPrDl2Fg
         KdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792502451; x=1793107251;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1aDjPA8RRZSC5RYtmkxavzjaFEuPSiecALjC0nZN+Aw=;
        b=SqpkjnKyOsKIRM7nm4rULbbSm8PMmKFOVpsABmAMQE2bdminPHH/NimPSxzoA68Ze5
         Z2XrKZADSIcrxVYdSU7y6VIg21IY92IrbLVBbNCteZoGNli7+47TcgYKeQ/aYv8ldVmQ
         paVVE/1M0LOqd/0Vj6xhhXNVkl1BPg/Ya3clbeUbLwBX2rNChiIEPfATw+LriN3fOSYU
         K3brJmWU2sKeiycJuVq+r5hUQR1fxmCjG38/LpjF/MepFirKlipG25PC2JaUqa4UHK4c
         YKNL4giXkumaYCCrz8bMB3VPeBf7Gg53UNXo6fS7e/TSJEsOzPkO2p+7NeeiprA2XDGf
         mlNQ==
X-Gm-Message-State: AFq9FYKTkzVRWS/1G1uDfk9s0edHUUVZ1AylpzqCrEMZgkjRPtYg121Z
	iAzoflONUdNsg9UstFHbNvuoBkDZ4x8zyyRnAx8vJ20JvFsH9hflnl8g7ce8RMNa
X-Gm-Gg: AYBFou1c0upOUio1GXmfPOeG5JhrGSDxlNTu60S8CgjpbL2zVtowi6dzGNdxgRvAaA/
	8HbQaQ8dypFQQvtp7mjWBbQEQnLiFw394ZPoNVtfz/JvfCmxRoeQ25OHVCCra0bYIh+dyFMOaHt
	frzoOM/J01u639j+abqRVxOn6N67u4qcxThD0eiI/TgroPmM5LLy90MExQHWEYxZ29rgJvjnqr5
	5g0mXjG6LXZeJoA6hyc8nWzm8OwbPOMXxm95KJnRZrl57CNqP6HvXbucULdtG2Ay7WMtg91HK7F
	0Erfo0Bba91ppERNs1ej+dgaf1datzwdSZdFFqjc3f8Nvp0BZevDl7nqV5OgIXJKPUBCFtCDO9C
	s2HsiBn+AkI8Mgc45JbTA+AveYuvgdvklRvuhrHhs3ODopM1lqPyTrzPlgoNtHr9bAHkEr0B4Vj
	d6LLM7GwogS6FC6M+O4nGAeEG1iSNICX6vjy1hugN1saN08Aa/+mZk/mQcxKcpoWtzO98cLaBQI
	N1VDDpLVL42NsoT9T34WI8MOQDBFkB6VCV1D9/lpnsSQVOB7DKGFjTzJzbX5IoOrkvCAJo/+3XF
	5/D3LMJ/KUCaQDThwmbo+8Mqjw6/r6U6N21ivgIgNoNIwMBf
X-Received: by 2002:a05:6a20:6a2b:b0:3e0:eae8:7525 with SMTP id adf61e73a8af0-3e22605a105mr9382056637.64.1792502451093;
        Tue, 20 Oct 2026 06:20:51 -0700 (PDT)
Received: from EAIT-H54D9Q2FJQ.eait.uq.edu.au ([130.102.10.249])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd654a0cf97sm4846882a12.24.2026.10.20.06.20.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Oct 2026 06:20:50 -0700 (PDT)
From: Yu Zhang <yuz08559@gmail.com>
To: Mike Christie <michael.christie@oracle.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yu Zhang <yuz08559@gmail.com>
Subject: [BUG] scsi: target: iscsi: Text/SendTargets command reuse -> NULL-ptr-deref / UAF in iscsit_build_sendtargets_response() (remote)
Date: Tue, 20 Oct 2026 23:20:43 +1000
Message-ID: <20261020132043.99594-1-yuz08559@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A remote iSCSI initiator can crash the target (NULL pointer dereference in the
TX thread) by sending two Text PDUs that reuse one ITT.  The same reuse also
yields a use-after-free and conn_cmd_list corruption.  Everything below is
against current mainline (drivers/target/iscsi/iscsi_target.c); the paths are
unchanged from v6.x.

Root cause
----------
The ISCSI_OP_TEXT dispatch, for a Text PDU whose TTT != 0xFFFFFFFF, looks up an
*existing* command by ITT with no state check:

	case ISCSI_OP_TEXT:
		if (hdr->ttt != cpu_to_be32(0xFFFFFFFF)) {
			cmd = iscsit_find_cmd_from_itt(conn, hdr->itt);
			if (!cmd)
				goto reject;
		} else {
			cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);
			...
		}
		ret = iscsit_handle_text_cmd(conn, cmd, buf);

iscsit_find_cmd_from_itt() returns any command on conn_cmd_list with a matching
init_task_tag, regardless of its state.  A SendTargets command stays on
conn_cmd_list after its response has been sent (i_state ISTATE_SENT_STATUS); it
is freed only once the initiator's ExpStatSN acknowledges it
(iscsit_ack_from_expstatsn()).  So an initiator that does not acknowledge it can
hand the same command back for reprocessing.

iscsit_setup_text_cmd() then frees the text buffer and clears the pointer, but
leaves the previously set ICF_SENDTARGETS_SINGLE flag on the command:

	kfree(cmd->text_in_ptr);
	cmd->text_in_ptr	= NULL;

iscsit_process_text_cmd(), seeing a NULL text buffer and a non-default TTT, takes
the empty-continuation path and re-executes the command:

	unsigned char *text_in = cmd->text_in_ptr, *text_ptr;
	if (!text_in) {
		cmd->targ_xfer_tag = be32_to_cpu(hdr->ttt);
		if (cmd->targ_xfer_tag == 0xFFFFFFFF) {
			...
			goto reject;
		}
		goto empty_sendtargets;
	}

On the TX thread iscsit_build_sendtargets_response() then dereferences the NULL
text buffer, because ICF_SENDTARGETS_SINGLE is still set:

	unsigned char *text_in = cmd->text_in_ptr, *text_ptr = NULL;
	...
	if (cmd->cmd_flags & ICF_SENDTARGETS_SINGLE) {
		text_ptr = strchr(text_in, '=');	/* text_in == NULL */
		if (!text_ptr) {			/* checked too late */
			...
		}

strchr() dereferences the NULL pointer before the !text_ptr check can run.

Note that LIO never assigns a target transfer tag for Text (it always sets
cmd->targ_xfer_tag = 0xFFFFFFFF in iscsit_setup_text_cmd() and rejects
multi-sequence Text in the same function), so a well-behaved initiator never
sends a Text PDU with TTT != 0xFFFFFFFF; the reuse path is only reachable by a
hostile/buggy initiator.

Reproduced
----------
KASAN kernel, demo-mode LIO iSCSI target on loopback (authentication=0,
generate_node_acls=1), iblock backstore.  A custom initiator logs in to Full
Feature Phase (normal session), then sends two immediate Text PDUs:

  PDU #1: F=1, ITT=0xaabbccdd, TTT=0xFFFFFFFF, data "SendTargets=iqn.<x>"
          -> allocates the command, sets ICF_SENDTARGETS_SINGLE, links it on
             conn_cmd_list (harmless, normal SendTargets response is sent).
  PDU #2: F=1, ITT=0xaabbccdd, TTT=0x00000000, empty data, ExpStatSN not
          acknowledging PDU #1 -> finds the same command, frees text_in_ptr,
          re-executes it.

The target panics immediately:

  BUG: KASAN: null-ptr-deref in strchr+0x13/0x50
  Read of size 1 at addr 0000000000000000 by task iscsi_ttx/3430
  CPU: 0 ... 7.1.6
  Call Trace:
   strchr+0x13/0x50
   iscsit_build_sendtargets_response.constprop.0+0x18b/0x950
   iscsit_build_text_rsp+0x94/0x380
   iscsit_response_queue+0x3b3/0xd50
   iscsi_target_tx_thread+0x2b6/0x500
   kthread+0x211/0x270
   ret_from_fork+0x333/0x590
  BUG: kernel NULL pointer dereference, address: 0000000000000000
  Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:strchr+0x13/0x50
  Kernel panic - not syncing: Fatal exception

Because SendTargets is how initiators perform discovery, and discovery sessions
are frequently unauthenticated, this is reachable by a remote peer that can open
a session to the portal; with panic_on_oops it is a remote crash.

Two further consequences of the same reuse (same root cause):
 - Use-after-free: if PDU #2 is pipelined while the TX thread is still walking
   g_tiqn_list for PDU #1, iscsit_setup_text_cmd()'s kfree(cmd->text_in_ptr)
   frees the "SendTargets=iqn..." buffer that iscsit_build_sendtargets_response()
   is reading -> KASAN use-after-free read.
 - conn_cmd_list corruption: if PDU #2 carries a non-empty "SendTargets=..."
   payload with the same ITT, iscsit_process_text_cmd() runs the unconditional
   list_add_tail(&cmd->i_conn_node, &conn->conn_cmd_list) on a command that is
   already linked.

Note for a fix
--------------
Guarding text_in before the strchr() in iscsit_build_sendtargets_response()
addresses only the NULL dereference; the use-after-free and the list corruption
come from reprocessing an already-processed/linked Text command and are not
covered by that guard.  A complete fix likely has to reject reuse of an existing
Text command via the TTT != 0xFFFFFFFF path (LIO never hands out a Text TTT, so
there is no legitimate continuation to honor).  Exact approach left to you.

Reported-by: Yu Zhang <yuz08559@gmail.com>
