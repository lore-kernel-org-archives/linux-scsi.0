Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795518302;
	b=C2MwRYA8EKGRhfhClZaX0f3D/ywKEWzYddoVro+eG30crsufIZ47nJsKunETyRld2P7l
	 PTcKbHBhjAC2KybjoZoHK6eaBqMLwzDlV+ZqdlJ08k53DWxNfVspQUqmpLoQI8J6mlUYC
	 BQLSYXtbl6BVdFb1KWtHVj4Vl1H9UvsKWIGrL4PbxCzKuirbWnG9036u2Dxhw0oNnklvc
	 Plr+umczNyMVA7P/+zuKTwmBw+Fsj+fmystrQN/fYAWvIFDdNNhnX6NV3VsOEW/wrfxn1
	 TrYqeAMMvlr4CT0QwCRXamK3VCNTq4rirZESZaebV1CVyGkPa0HgHC+5ajiwJlIphLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795518302;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=IErW237nxPTFPaxaUwE6T2gUhM4FsxHtoM7AbkyU5fk=;
	b=nOQlvyMByL0ZR+z1ma1EjtnxrujrwJj+B7kebZLBiPSIsbjXmCrB+1QJ5UZRGpb5yOMl
	 AL2JymHKLP2nE1NN/o/D7YGgqzEay8rqm8Urw8GLlkT8hffBzKU60vnauVLndjwXaJEfc
	 M0uJu+lte8CCKG8MxJ1ud1ZW6RVLLaUkjieAzNEaKtVs8oL8KiyQ/4SRybEIXhVpaZrX+
	 nitjF+bt1OCPeFYhqfGb9Jt/qYj/CUpTpW75xcXIeM8nQdDZFgg2dw3lDFichCJX8HFtk
	 nktPEGq6sCRrtERjJ4+eiobP3CnGjIvqpP0kB77Wh1Vw9agj65v6+lxrVOzsARIsuLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=htfm9XbS;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5910F606A31E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 11:05:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5910F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=htfm9XbS
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4a358881793so2218575f8f.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 03:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795518301; x=1796123101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IErW237nxPTFPaxaUwE6T2gUhM4FsxHtoM7AbkyU5fk=;
        b=htfm9XbSkowDG1HsPGkmA1Sa/7zaV+wWGP1J9/RfRjdXzcadB/IX5iZ7CKKbCE/wON
         2Y/Uy4xb/r8c65S58x7GY/IOwTubgUbX7C+SUEAtnnKclmBC6QqWDxFESTWoYvnbgXpU
         ginGIHc/XomswKuW2VqhWlftpVZWSbVHFaUVvAaAB437Fa3I+upAehzT4i0WE+EjN1sM
         NcAXVyLu2F/v9RVPg1XaTZck5e5XzlPf3I2u1oce4Nnnz1khu6ZB3AO/p3RaMkmtRdyk
         oo7tUxr27J1hXPNlV+igwQpWhBDiMvtD/Ipbb1RrJH0YkRyeK/XCFRHH/iPlI76tZvdp
         DmqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795518301; x=1796123101;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IErW237nxPTFPaxaUwE6T2gUhM4FsxHtoM7AbkyU5fk=;
        b=16k190m0kTK8jKNiMx9Cvpt66dI/WMj/XGGN3R25n/YqaPftlh02OT3yJXX/5sVzQI
         /gHq2woLNpGhw4gGyTNx5rFzHrggMRmhJLIK7K2TGjak/1soOvFvuGd6fMToT7pdXMbW
         USX1pdR3niRwOVlEF+SfU7A1Xg0+9KfNmSH4qsfaD7gZ5bDaZiG7F82Zss+mStTGfC2B
         W7aEnQf5Cma1ZItiT8sk1SX4LAylQEAigdSP+EjH5aKqW6dqgkOJQ5hdB6d7RuT2cAXk
         VGqddgw9q0JS9K6Vsv4btUifYJ0sHKUBIRQmgle8eWnHxB/EOBekPHfjipCZDmYAdSJS
         lizA==
X-Gm-Message-State: APuU4Z8jAA6HmL/J35Hz7nQBXea+/Q/QBjdGXGI+fvPc5LjpybuueRQz
	iax+agPrkebnm++e8Z6m7OdoSiLnVA/yg4ML2eElfLrbSzOZ4ISPMiQt8kh7Mgmn
X-Gm-Gg: AZFdTZfOj01zLkGBKUnA8Kx9Ww6k6FGU93uWK8Kj6TNUx3dqUxg5qwFJNHkb9qaerk0
	Gf00hOEncIRy7BfDzzaicNw1mq3YGmG3iqggdPSKeSC6vWQ3qOzgS8xxn4w/KvQEyiLujBu31QB
	wfDNXvo/Mq1G5cE5wOlqQWZyRcM61tZtNzrDKr9qKhJyIxGxsfAz6b+g7pyyhvIRs+X0t3ZtgZ/
	AtiKZB34ahgMWj/c1glGxuCToemRH8dbwKNx8auT/nPCvZWXQnwCKqJUqYuZKazKYj+DJFRDfa7
	8+NkYCuFzf6EYWQ7ePAI8MONdY8kPOzqATyVqtD2DeQCLHr96jyd8gsCEJWkW2n6WTWzAMOk38z
	bZu3WvC7L/1Q5KKwcbiNn1i3TQFF2vqUIV/dsHxT+SbpahVMYVvvxQ+CON9Px5LkkVPizPGA3y4
	KpMYLc/5oEXg7h3xIG8mEM6CLMPAPszXrfSU6azcs8na9/T/eeldxD3/876AOwPoDeXNVD9x8jp
	Q9sV/Mh5gNM/HiItSlt9O38RmT3pSylcXx1hWtAR2qNyvyoVP3nfMVM5kwqV3wHUODx8AvHLMfp
	Od5eJsooEULkoePQ2ahmahCJqBxrzG6sJltMMb8s
X-Received: by 2002:a05:6000:470c:b0:4a6:ad0e:6cd4 with SMTP id ffacd0b85a97d-4abb759dd4dmr26347062f8f.48.1795518300394;
        Tue, 24 Nov 2026 03:05:00 -0800 (PST)
Received: from localhost.localdomain ([91.223.207.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6bb989eesm27402010f8f.50.2026.11.24.03.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 03:04:59 -0800 (PST)
From: Benjamin Saiz <benj.saiz@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	aacraid@microsemi.com
Subject: [PATCH RFC] scsi: aacraid: free aborted management FIBs on late completion
Date: Tue, 24 Nov 2026 11:04:44 +0000
Message-Id: <20261124110444.3485-1-benj.saiz@gmail.com>
X-Mailer: git-send-email 2.39.5
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

When a signal interrupts a process waiting in aac_fib_send() for a
management command (for example FSACTL_SEND_FIB from arcconf, maxView
or smartctl), aac_fib_send() marks the FIB as abandoned (done = 2) and
returns -ERESTARTSYS. The ioctl handlers then deliberately keep the
FIB, because the controller still owns it: ioctl_send_fib() only calls
aac_fib_free() when retval != -ERESTARTSYS, and aac_send_raw_srb()
does the same. The interrupt handler is expected to release the FIB
when the late response arrives.

aac_intr_normal() handles that late response but only calls
aac_fib_complete(); it never calls aac_fib_free(). The FIB is
therefore never returned to the free list. Since commit 6bf3b630d0a7
("aacraid: SCSI blk tag support"), the free list only holds the
AAC_NUM_MGT_FIB (8) management FIBs, so eight interrupted management
commands exhaust it: aac_fib_alloc() returns NULL and every later
management ioctl fails with -ENOMEM until the adapter is reset or the
host is rebooted. management_fib_count is decremented normally, so the
"No management Fibs Available" check never fires and nothing is
logged.

The exhausted pool also prevents aac_send_shutdown() from allocating a
FIB, so VM_CloseAll is silently not sent at shutdown.

Observed on an Adaptec 6805 (Linux 5.10) with kprobes on aac_fib_send(),
aac_fib_complete() and aac_fib_free(). Before the test, 1000 management
commands all used the same FIB. arcconf was then killed (SIGKILL) while
waiting for a ContainerCommand:

  54803.925692 arcconf-1091331, CPU 11: aac_fib_send() returns -512
  54803.927570 <idle>-0, CPU 12, hardirq:
               aac_fib_complete(fib=0xffff96570a8e7b00)

The late response arrived 1.9 ms later in hard interrupt context and
completed the FIB, but aac_fib_free() was never called for it. The next
812 management commands all used another FIB; 0xffff96570a8e7b00 was
never allocated again.

Commit cacb6dc3d7fe ("[SCSI] aacraid: fix File System going into
read-only mode") introduced the done = 2 handshake and freed the FIB
in both aac_response_normal() and aac_intr_normal(). Commit
6bf3b630d0a7 removed the aac_fib_free() calls from aac_intr_normal(),
as I/O FIBs became indexed by block layer tags and must not be put on
the management free list. The abandoned-FIB path, however, only ever
sees management FIBs: every synchronous sender (wait != 0, no
callback) gets its FIB from aac_fib_alloc(). Commit 423400e64d37
("scsi: aacraid: Include HBA direct interface") restored
aac_fib_free() for the callback-less async case but not for this one.
aac_response_normal() still frees the FIB.

Free the FIB after completing it in both the native HBA and the
regular branch. done is set to 1 before the call, so the early return
in aac_fib_free() for done == 2 does not apply.

The issue was found, and this patch and its changelog were drafted,
with the help of an AI coding assistant (Claude). I reviewed the
analysis and the change and take responsibility for them.

Fixes: 6bf3b630d0a7 ("aacraid: SCSI blk tag support")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Saiz <benj.saiz@gmail.com>
---
RFC because the fix itself is only build-tested (x86_64, v7.0 headers,
W=1, no new warnings). The leak was reproduced on the affected host as
described above, but that host is a production NAS (Adaptec 6805,
Debian 11, Linux 5.10) and the patched module was not loaded there.

Every synchronous sender (wait != 0, no callback) in aachba.c,
commctrl.c, commsup.c and comminit.c gets its FIB from aac_fib_alloc(),
so the done == 2 path cannot return a block layer tagged FIB to the
management free list.

For reference, Microchip's out-of-tree driver 1.2.1-60001 frees the FIB
at the same place (both done == 2 branches of aac_intr_normal()); its
aac_fib_free() only returns pool FIBs to the free list.

Not addressed here: on -ERESTARTSYS, aac_send_raw_srb() also strands its
SG buffers and DMA mappings (bugzilla 220504).

 drivers/scsi/aacraid/dpcsup.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index 169c41d..a965f18 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -379,8 +379,10 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u32 index, int isAif,
 					mflags);
 
 				FIB_COUNTER_INCREMENT(aac_config.NativeRecved);
-				if (completed)
+				if (completed) {
 					aac_fib_complete(fib);
+					aac_fib_free(fib);
+				}
 			}
 		} else {
 			struct hw_fib *hwfib = fib->hw_fib_va;
@@ -432,8 +434,10 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u32 index, int isAif,
 					mflags);
 
 				FIB_COUNTER_INCREMENT(aac_config.NormalRecved);
-				if (completed)
+				if (completed) {
 					aac_fib_complete(fib);
+					aac_fib_free(fib);
+				}
 			}
 		}
 
-- 
2.43.0

