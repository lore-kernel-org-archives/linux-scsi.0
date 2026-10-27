Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793104340;
	b=kzZk3Pn5E6B+t/lsT/5dbN8SrhPPanAn1WRh26PXG66rqxjsnaGnJ4U7ZnRyDtzWPprZ
	 nVTiJkwP5ON92WtQuA3vORBjV3bQo8TCTGAqHVm6YKQsk/uvmi+Uya2fk3cTszpUlYxTl
	 thyma2h0pjypwnhTXIXA4hvBcyfDoZwg0zrM1qOBh2mOwuPjj9j4eCL7CCiGdv6EQrw1c
	 3qnzzdRZIdUt/nl4qY0vM+oWrLs91a+uI9xWXSXJ+8keWF4Vpf2bdTdvlf+dIDIv/z/2s
	 li9RGHIE8i4tDGQ+3fl55TiadKYHk3iizTZbxQWCYJEjcYukQOJ2bX6u/+YRHmfmYkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104340;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-META:X-CID-BVR:
	 X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=D/JBPkvv/qyx1+277tmAX2f1cVbpMop2ccu3ZRTgyrk=;
	b=RpQkdhUJjhPfSFKpB4zMplQBGP7mL2TRm7IpQdUex4imTdYVlGfLAxSThD40FPTo4LqT
	 jRr3d2H4w17RBAZ0sIWAe8FzzKDPtIxDYc8W7o5FSMkXAuUIPPo67f1gYxTRuFHP+Y7RQ
	 ZxEW8YPfmY1oqeKeFPH0LGmB6u4crduwDTDXuF7fxH1kaU5ZKlum80Y41HlGRXf2XX4aQ
	 TtiJppq0ZVxcRXXm0koH6ZWZfDZF4kYTAgXB9x9AnKXQdhVv8pvznuRw9Eczy2AAAKOwF
	 l8zCISD+nFWGEDsDw/2mFaY/PmpohamkblcRKgqvw+oziu64I0OfVCJJOxN5HPDuqDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A42C606A31E;
	Tue, 27 Oct 2026 12:32:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A42C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 6e8d6306d20211f19a56ed5b684f684d-20261027
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:12316910-0ca6-4cc6-898b-f2e94ee5b24a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:3e25585a5367c03d8bfd50d1bffd8b8c,BulkI
	D:nil,BulkQuantity:0,SF:81|82|83|102|865|898,TC:nil,Content:0|15|50|99,EDM
	:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6e8d6306d20211f19a56ed5b684f684d-20261027
X-User: lijiayi@kylinos.cn
Received: from thinksys.tail1c7620.ts.net [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 383760322; Tue, 27 Oct 2026 20:32:11 +0800
From: Jiayi Li <lijiayi@kylinos.cn>
To: Oliver Neukum <oneukum@suse.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Michal Pecio <michal.pecio@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: uas: wait for pending commands before unbinding
Date: Tue, 27 Oct 2026 20:31:50 +0800
Message-Id: <20261027123150.976281-1-lijiayi@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <caa4542a-f1af-4a24-bc1f-f6c17d6e93ee@suse.com>
References: <caa4542a-f1af-4a24-bc1f-f6c17d6e93ee@suse.com>
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

Thank you for the follow-up.

On Tue, Oct 27, 2026, Oliver Neukum wrote:
> Even if an error occured? Does it make sense to wish to complete
> commands that have failed while the driver is being unloaded.

I have changed the disconnect preparation to stop retries after
allocation or URB submission failures. After blocking the host, accepted
commands are marked with COMMAND_NO_RETRY. Commands needing a retry are
left for the existing cleanup, while other accepted commands can still
complete normally.

The wait now polls the command table, excluding commands left for cleanup,
rather than waiting for anchors that those commands may still occupy.

> Indeed, but shouldn't we cancel scan_work _before_ we even try to complete
> commands?

I have added cancel_work(&devinfo->scan_work) before blocking the host.
This cancels pending scan work without waiting for a running scan.

> Understood. We need a genuine cancellation code.

Is additional cancellation handling required for this change, or can
it be addressed separately?

> Yes, but that doesn't answer you why you are setting resetting
> only _after_ waiting for commands to complete.

resetting also suppresses normal completion processing:
uas_stat_cmplt() skips processing the received IU, and uas_data_cmplt()
skips uas_try_complete(). Setting it before the wait would therefore
prevent some accepted commands from completing normally.

During preparation, scsi_block_requests() prevents new commands from
being accepted while existing commands retain their completion paths.
I set resetting when the wait ends, including on timeout, before
unblocking the host.

> This answers it, but why do you unblock the device then at all?

The temporary SCSI host block needs to be released so queued requests and
requests issued during device removal can finish. For example,
sd_shutdown() may issue a synchronous cache flush. Leaving the host
blocked can leave that request waiting for dispatch.

With resetting already set, requests reaching that check in
uas_queuecommand_lck() are completed with DID_ERROR without submitting
new URBs. This restores the existing teardown behaviour after the
grace period.

Thanks,
Jiayi
