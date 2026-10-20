Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792473997;
	b=hrrshB9EMR7wljHdvyJcTtnMQH83hBE6R9BHtsHaTX8x6/pxkhevXz/xyVmHzLiggHib
	 1qhQB/O760PbdPrMdxT46zuIih9X4YAGWRatmaa7uESeqjpRCZ7/rq31sg3bF5dNzehLh
	 ZeaDzcCjW/gTmBUgMVI+80BnQFW45oUSbcwM7JcJ50xm1QqAUpZKUl6j0uWgoEiji/6Zd
	 1Kn8F0Rs8bYY9N0TklbC9z6T3OS3n2TPOEehw6Zzw+tXzj7/A2ga1xZN458dPHAJbZjfz
	 YSvjH/izlQEL8pbsDL9eUn9R8pdf0y1eL/1yQL8e+Li4Slrd1Nbg0h8MrcoKNE8Z3KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792473997;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aAoBa2XKmpxRpiupLYxkkovbXZbnGD/HM9ChTgD3OeM=;
	b=YCA24dNVrqtVsiUfd32XGgpLutXJlQhDJsvDVKohrkZWJ1gZslQw+3aeMESXSrOwBADb
	 ceHcFfxPoh4bDxHktJSMxWpAuXtVAoQhNB10MJeQfROVo6AbVSfAElJ1apMC934DvFb+4
	 +Xc1K2pCYerAYhYpRkYPYPFK2G5Qk4DyTzC6E7Ocp/9y58LTHo+NDNTficxkbmx1HIwer
	 aJ9zDV1Qta95YMKvVxM0TkYFFxI+vJTHayycW04WSPSYhE/Odtu1ikiyNjM/IVbB5fM0B
	 GzCDsYOm0ROf3AO8MecMcyp1Mjs2H+OrpllTE2BnWrf2XQjdaDNbSQQC7EOcwaTjyBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=h0U1n0H5;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555FF606A31F
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 05:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 555FF606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=h0U1n0H5
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3a7cfe8f761so207428a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 22:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792473997; x=1793078797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aAoBa2XKmpxRpiupLYxkkovbXZbnGD/HM9ChTgD3OeM=;
        b=h0U1n0H5zLnvozX4Nlm1AdMvhnDTDAXJYameJ14WLzssl5HGlZ7WVzhjyxO9km8Uw7
         zY/0p430Ev+gZ1J88ndGl51huFK+T7hilf8z5faYunvU3Uf8LJPKhakd8YYB6YJ46fij
         obTsj8cPXcRhY9RvlPYn9rTYd+mhCXcF52oiCnayoHBJUPCMSNvjmbRxF/CenImEuPIo
         Fz/hQ4IXViYUQQLOhBtjsJk9fJR5utSpbbknSeUIgUACDmdF/Zt4APTvfu/pU/MI6ZG8
         olTK4QkAJudaJYAjF+M+mG+jJ25h6XGPCbdW8ok8HMgD25rLJ3z5SPbEp+NaWkm1pTyW
         ohWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792473997; x=1793078797;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aAoBa2XKmpxRpiupLYxkkovbXZbnGD/HM9ChTgD3OeM=;
        b=jvhpRfHewU8asGskb2eRR+ITRXEyObUgtKhFoM/4DIiLGv1uwQcRd2OzjQTKjnIttU
         sa1NKhfL3mrK6FSJM0w6cAqQ0ZvqVkQUl8IRTERtL1AcXPktQWECHZ1zN4FnM0Y/IotT
         1PYFlUNnBiIxHDz8lKlBOUeRMwbAfufNxNDe0AgwCLWChj1D+ymZp8NMYkjn8Jy1/X/N
         2pdRVM82e9dby9q4rZNPtM3Cp0Bn7RHmR+P1mLvNGVu81DHlxRvNUq/u0MOMYUj8KYSZ
         YpW26OqMWZgAepXSZxPlCcIs35fLCX5FlIqmlvLK1n+ErdI/ink4SrxoJB0xKWHe5BXY
         BjLQ==
X-Forwarded-Encrypted: i=1; AKwUvBzi7kEvzJJl5XfgKiepVqrkRoLyfbGXU3EPd39CZvaYrNSRow0hvDtlBOnun5BiCQ9GNDEtZ8Ceclh4@vger.kernel.org
X-Gm-Message-State: AFq9FYIWB3y9iCg8vNnOv6/ANlBGGEL0M37xOaGNL1RqhvNjLYksOwXR
	+bFMD57qGObqZEbGh3UKIr2ntUJ65EqzlHZO2g3gMT68JR+PaCZvQBAf
X-Gm-Gg: AYBFou1wqf5zehOUSBr75NRdb738ogfe+6BeaRrNIeJ4x2jhjluDXrCgK3cYv4mWLXx
	Nui2vKtPpDxetdd9AiR/zzzlR/D5zQzoYdbqHoT3RYp4TU0a8JvRIUjKSmwgB9Fni1wyfxJyDRO
	ttuG0Ptpd8zLzrurPZ5Ew3mC3OVft1QLEUkh7CMmr8t/9tq6pyYuwPiiqTOo1/x6APMz27oz/jL
	qkp5QKWtLx/ZbbajmbeMwWQX3rjSPBrpiQGiMdo4rFrpNnnSwh4+Fm3fvD/bC5xa5HkFHD/43iL
	ul4bDzsXVP6kUpqeac5jm1ubNHas03Bwe7OWv1IAtVqjXZWAT2bKjFNciHFxOQDajgnGOpSUXi9
	EqlVqORHnQOVQlGSBxq//qEoXfRTtj367Rs6vkUcO4e48LXkJ4AtVF+iikR51Y5bDghzcVUhm2s
	lRHF8EihkFmBicqZTavxWkR1NLJb4ps+eaD0NHVEqKQJ32OoGmDp+0eqH/V02avlSQh8YnF+LvH
	nBnK1F1aUjRyHytxlRoyq6PBLjGCd15iNTT1sGO3iK3+xmkTvr8Je07UszAUohL2zBNGrkZ4IIS
	2Ff2WMNUMyxAywb3J9GEUe7zZT9sSyscnHJQ/pBktG0zJuuc
X-Received: by 2002:a17:90b:4ac9:b0:3a0:cca0:4a8c with SMTP id 98e67ed59e1d1-3ad64b90b64mr679523a91.7.1792473996598;
        Mon, 19 Oct 2026 22:26:36 -0700 (PDT)
Received: from EAIT-H54D9Q2FJQ.eait.uq.edu.au ([130.102.10.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad5d4004efsm2373582a91.5.2026.10.19.22.26.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Oct 2026 22:26:36 -0700 (PDT)
From: Yu Zhang <yuz08559@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Christie <michael.christie@oracle.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-usb@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] usb: gadget: f_tcm: NULL-ptr-deref / use-after-free when the UDC is disconnected during in-flight target I/O
Date: Tue, 20 Oct 2026 15:26:29 +1000
Message-ID: <20261020052629.92551-1-yuz08559@gmail.com>
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

Hi,

f_tcm frees its per-endpoint USB requests on the teardown path without
waiting for in-flight target_core commands to finish, so a command that
is still being processed by the backend when the gadget is disconnected
completes into freed/NULL request memory.

The teardown path (host disconnect / port reset, "echo '' > UDC", or
set_config 0) reaches the function's ->disable:

  tcm_disable()                                 f_tcm.c:2562
    tcm_cleanup_old_alt()                       f_tcm.c:2366
      uasp_cleanup_old_alt() [UAS]              f_tcm.c:538
      bot_cleanup_old_alt()  [BOT]              f_tcm.c:365

bot_cleanup_old_alt() / uasp_cleanup_old_alt() disable the endpoints and
then free the request objects and NULL the pointers, e.g. (BOT):

  usb_ep_free_request(fu->ep_in, fu->bot_req_in);
  ...
  fu->bot_req_in = NULL;                        f_tcm.c:383

(the UAS path NULLs stream->req_in/req_out/req_status the same way, and
tcm_unbind()/tcm_free() later free descriptors and the f_uas itself).
There is no target_wait_for_sess_cmds() / command drain anywhere on the
disable/unbind path -- the only thing cancelled is the delayed_set_alt
work.

The SCSI session (I_T nexus) is owned by the configfs TPG, not by the
gadget function, so unbinding the UDC does not stop or drain the
in-flight se_cmds: they keep running in target_core and complete
asynchronously. The completion reaches the fabric queue_data_in callback
with no check of endpoint/teardown state:

  target_complete_ok_work()
    se_tfo->queue_data_in == usbg_send_read_response()   f_tcm.c:1175
      bot_send_read_response()   [BOT]                   f_tcm.c:209
          fu->bot_req_in->buf = cmd->data_buf;           f_tcm.c:232
      uasp_send_read_response()/uasp_prepare_r_request() [UAS] f_tcm.c:574

fu->bot_req_in (resp. stream->req_in) has just been freed and set to
NULL by the concurrent teardown, so the write faults. The queue_status
path (usbg_send_status_response) touches the freed req_status in the
same way.

KASAN, reproduced:

  BUG: KASAN: null-ptr-deref in usbg_send_read_response+0x377/0x560
  Write of size 8 at addr 0000000000000038 by task kworker/1:0/23
  Workqueue: target_completion target_complete_ok_work
  Call Trace:
   usbg_send_read_response+0x377/0x560
   target_complete_ok_work+0x499/0x850
   process_one_work+0x46c/0x970
   worker_thread+0x395/0x6e0
   kthread+0x211/0x270
   ret_from_fork+0x333/0x590
   ret_from_fork_asm+0x1a/0x30

(offset 0x38 is req->buf: fu->bot_req_in == NULL after bot_cleanup_old_alt()).
If the teardown has also reached tcm_free(), cmd->fu is dangling and this
is a use-after-free of the f_uas instead of a NULL deref.

== Reproduction ==

f_tcm target on dummy_hcd, KASAN. dummy_hcd defaults to HighSpeed, so the
function runs in BOT mode and the host side binds usb-storage.

  - backstore: brd /dev/ram0 behind dm-delay with a 300ms read delay, so
    a READ stays in-flight in the backend; iblock on the dm-delay device.
  - target: /sys/kernel/config/target/usb_gadget/naa.<wwn>/tpgt_1 with a
    LUN linked to the backstore and a nexus, enabled.
  - gadget: usb_gadget/g1 with functions/tcm.0 linked into a config,
    bound to the dummy UDC; the host enumerates /dev/sda.

Then:
  - task A: continuous O_DIRECT reads of the host /dev/sda (each becomes a
            real READ(10) to the gadget, parked 300ms in the backend).
  - task B: echo "" > g1/UDC   (disconnect while a READ is in-flight)

The in-flight READ completes on the target_completion workqueue after the
teardown freed fu->bot_req_in, and bot_send_read_response() writes through
it. The dm-delay read delay only makes the window deterministic; on real
hardware the window is the backing-store latency, and a plain cable
unplug / host port reset during I/O takes the same ->disable path.

The disable/unbind path frees the endpoint request objects but nothing
waits for the target commands that still reference them to drain.
