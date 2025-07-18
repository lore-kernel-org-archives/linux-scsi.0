Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480D62E62B3;
	Fri, 18 Jul 2025 18:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752863421; cv=none; b=RuyB9OW1JAYdMa5xeMRz+G5C2j8YWHVhAWqWXHHMJh2lgj1s3MUUuOsWDkzOXfRkMwVUBGwm6W/vNAqLwU3V28BQS5RVPsW9LXgEp0hLRbU4cVtA3RS44yLkJuzTn6zOEg4bEbYXdqUsdEmd3EmhNnGDOAbCCzBf+GKeqB6EI1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752863421; c=relaxed/simple;
	bh=a4ziKATIdSK3OIJk9Tg8WEk1qn/1OtkcPtI0RS4MVf0=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=Vybf0d8FPJxEi8vUb808Y0UKkR0CcTSlWb4eY/E0woQFex92HNIuNOowmLyetnMJTV+zDxI0RoOwygushF0b3Lg+3In42pOqK61K56nZ4f5c7T0iBYPZp1kuH7UMe1DY3mei+mtV9QAC75/q4Nw3EIkztADzzayzCyYtcvKdoYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bFAUey8+; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bFAUey8+"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bkJHm2w1Gzm0yTF;
	Fri, 18 Jul 2025 18:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	in-reply-to:from:from:content-language:references:subject
	:subject:user-agent:mime-version:date:date:message-id
	:content-type:content-type:received:received; s=mr01; t=
	1752863410; x=1755455411; bh=E66bZ8vdeU0JX+WNp5YbUGSqc082rc9YAdz
	6vsoKU7g=; b=bFAUey8+g7V7J77fw9X+us2RB18tEeWSD2vxUSWRsh+rxstOJuk
	V8zv5w98zJMOkhz0L9flPsOXCBkhYyLNK77uo70VfHbGf51H7wrKJfJM6gWOE6Dx
	6M0RR3ynA36gGNwnqNY6YOXfcTP/ky7EhbORKTDG5Kfbm0wN/x6B4OU+u5rPXxVy
	a9mKYvMc4ZNn8G2inE77To8wf9q8eGUrK2rD/wPENfd9fMpHOmyPSTvLRBJLcZi+
	pEzaB7a9G3JR2/5EY5351wfQ84k+adGCc2z5Wkj8zRZDCIwzV79WxD2myRveQyOe
	PqttY2N4abVmSjP1ryDtDF/Azf2zIRdGwfg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GOizYLUu2c3z; Fri, 18 Jul 2025 18:30:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bkJHg31VTzm174F;
	Fri, 18 Jul 2025 18:30:06 +0000 (UTC)
Content-Type: multipart/mixed; boundary="------------PrnkxU3HGbPtNZ8itRnKp7On"
Message-ID: <754540df-0039-47b5-ab60-44d6c4f7ac5a@acm.org>
Date: Fri, 18 Jul 2025 11:30:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 00/12] Improve write performance for zoned UFS devices
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250717205808.3292926-1-bvanassche@acm.org>
 <f1b3060c-f951-4184-886c-87ba812986a7@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f1b3060c-f951-4184-886c-87ba812986a7@kernel.org>

This is a multi-part message in MIME format.
--------------PrnkxU3HGbPtNZ8itRnKp7On
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/25 12:08 AM, Damien Le Moal wrote:
> How did you test this ?

Hi Damien,

This patch series has been tested as follows:
- In an x86-64 VM:
   - By running blktests.
   - By running the attached two scripts. test-pipelining-zoned-writes
     submits small writes sequentially and has been used to compare IOPS
     with and without write pipelining. test-pipelining-and-requeuing
     submits sequential or random writes. This script has
     been used to verify that the HOST BUSY and UNALIGNED WRITE
     conditions are handled correctly for both I/O patterns.
- On an ARM development board with a ZUFS device, by running a multitude
   of I/O patterns on top of F2FS and a ZUFS device with data
   verification enabled.

> I do not have a zoned UFS drive, so I used an NVMe ZNS drive, which should be
> fine since the commands in the submission queues of a PCI controller are always
> handled in order. So I added:
> 
> diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
> index cce4c5b55aa9..36d16b8d3f37 100644
> --- a/drivers/nvme/host/zns.c
> +++ b/drivers/nvme/host/zns.c
> @@ -108,7 +108,7 @@ int nvme_query_zone_info(struct nvme_ns *ns, unsigned lbaf,
>   void nvme_update_zone_info(struct nvme_ns *ns, struct queue_limits *lim,
>                  struct nvme_zone_info *zi)
>   {
> -       lim->features |= BLK_FEAT_ZONED;
> +       lim->features |= BLK_FEAT_ZONED | BLK_FEAT_ORDERED_HWQ;
>          lim->max_open_zones = zi->max_open_zones;
>          lim->max_active_zones = zi->max_active_zones;
>          lim->max_hw_zone_append_sectors = ns->ctrl->max_zone_append;
> 
> And ran this:
> 
> fio --name=test --filename=/dev/nvme1n2 --ioengine=io_uring --iodepth=128 \
> 	--direct=1 --bs=4096 --zonemode=zbd --rw=randwrite \
> 	--numjobs=1
> 
> And I get unaligned write errors 100% of the time. Looking at your patches
> again, you are not handling REQ_NOWAIT case in blk_zone_wplug_handle_write(). If
> you get REQ_NOWAIT BIO, which io_uring will issue, the code goes directly to
> plugging the BIO, thus bypassing your from_cpu handling.

Didn't Jens recommend libaio instead of io_uring for zoned storage? See
also 
https://lore.kernel.org/linux-block/8c0f9d28-d68f-4800-b94f-1905079d4007@kernel.dk/T/#mb61b6d1294da76a9f1be38edf6dceaf703112335. 
I ran all my tests with
libaio instead of io_uring.

> But the same fio command with libaio (no REQ_NOWAIT in that case) also fails.

While this patch series addresses most potential causes of reordering by
the block layer, it does not address all possible causes of reordering.
An example of a potential cause of reordering that has not been
addressed by this patch series can be found in blk_mq_insert_requests().
That function either inserts requests in a software or a hardware queue.
Bypassing the software queue for some requests can cause reordering.
Another example can be found in blk_mq_dispatch_rq_list(). If the block
driver responds with BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE, the
requests that have not been accepted by the block driver are added to
the &hctx->dispatch list. If these requests came from a software queue,
adding these to hctx->dispatch_list instead of putting them back in
their original position in the software queue can cause reordering.

Patches 8 and 9 work around this by retrying writes in the unlikely case
that reordering happens. I think this is a more pragmatic solution than
making more changes in the block layer to make it fully preserve the
request order. In the traces that I gathered and that I inspected, I
did not see any UNALIGNED WRITE errors being reported by ZUFS devices.

Thanks,

Bart.
--------------PrnkxU3HGbPtNZ8itRnKp7On
Content-Type: text/plain; charset=UTF-8; name="test-pipelining-and-requeuing"
Content-Disposition: attachment; filename="test-pipelining-and-requeuing"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCnNldCAtZXUKCnN0b3BfdHJhY2luZygpIHsKICAgIGlmIGxzb2YgLXQg
L3N5cy9rZXJuZWwvdHJhY2luZy90cmFjZV9waXBlIHwgeGFyZ3MgLXIga2lsbDsgdGhlbiA6
OyBmaQogICAgZWNobyAwID4vc3lzL2tlcm5lbC90cmFjaW5nL3RyYWNpbmdfb24KfQoKdHJh
Y2luZ19hY3RpdmUoKSB7CiAgICBbICIkKGNhdCAvc3lzL2tlcm5lbC90cmFjaW5nL3RyYWNp
bmdfb24pIiA9IDEgXQp9CgpzdGFydF90cmFjaW5nKCkgewogICAgcm0gLWYgL3RtcC9ibG9j
ay10cmFjZS50eHQKICAgIHN0b3BfdHJhY2luZwogICAgKAoJY2QgL3N5cy9rZXJuZWwvdHJh
Y2luZwoJZWNobyBub3AgPiBjdXJyZW50X3RyYWNlcgoJZWNobyA+IHRyYWNlCgllY2hvIDAg
PiBldmVudHMvZW5hYmxlCgllY2hvIDEgPiBldmVudHMvYmxvY2svZW5hYmxlCgllY2hvIDAg
PiBldmVudHMvYmxvY2svYmxvY2tfZGlydHlfYnVmZmVyL2VuYWJsZQoJZWNobyAwID4gZXZl
bnRzL2Jsb2NrL2Jsb2NrX3RvdWNoX2J1ZmZlci9lbmFibGUKCWVjaG8gMSA+IHRyYWNpbmdf
b24KCWNhdCB0cmFjZV9waXBlID4vdG1wL2Jsb2NrLXRyYWNlLnR4dAogICAgKSAmCiAgICB0
cmFjaW5nX3BpZD0kIQogICAgd2hpbGUgISB0cmFjaW5nX2FjdGl2ZTsgZG8KCXNsZWVwIC4x
CiAgICBkb25lCn0KCmVuZF90cmFjaW5nKCkgewogICAgaWYgWyAtbiAiJHRyYWNpbmdfcGlk
IiBdOyB0aGVuIGtpbGwgIiR0cmFjaW5nX3BpZCI7IGZpCiAgICBzdG9wX3RyYWNpbmcKfQoK
cWQ9JHsxOi02NH0KIyBMb2cgZXJyb3IgcmVjb3ZlcnkgYWN0aW9ucwplY2hvIDYzID4gL3N5
cy9tb2R1bGUvc2NzaV9tb2QvcGFyYW1ldGVycy9zY3NpX2xvZ2dpbmdfbGV2ZWwKaWYgbW9k
cHJvYmUgLXIgc2NzaV9kZWJ1ZzsgdGhlbiA6OyBmaQpwYXJhbXM9KAoJZGVsYXk9MAoJZGV2
X3NpemVfbWI9MjU2CglldmVyeV9udGg9JCgoMiAqIHFkKSkKCW1heF9xdWV1ZT0iJHtxZH0i
CgluZGVsYXk9MTAwMDAwICAgICAgICAgICAjIDEwMCB1cwoJb3B0cz0weDI4MDAwICAgICAg
ICAgICAgIyBTREVCVUdfT1BUX1VOQUxJR05FRF9XUklURSB8IFNERUJVR19PUFRfSE9TVF9C
VVNZCglwcmVzZXJ2ZXNfd3JpdGVfb3JkZXI9MQoJc2VjdG9yX3NpemU9NDA5NgoJemJjPWhv
c3QtbWFuYWdlZAoJem9uZV9ucl9jb252PTAKCXpvbmVfc2l6ZV9tYj00CikKbW9kcHJvYmUg
c2NzaV9kZWJ1ZyAiJHtwYXJhbXNbQF19Igp3aGlsZSB0cnVlOyBkbwoJYmRldj0kKGNkIC9z
eXMvYnVzL3BzZXVkby9kcml2ZXJzL3Njc2lfZGVidWcvYWRhcHRlciovaG9zdCovdGFyZ2V0
Ki8qL2Jsb2NrICYmIGVjaG8gKikgMj4vZGV2L251bGwKCWlmIFsgLWUgL2Rldi8iJHtiZGV2
fSIgXTsgdGhlbiBicmVhazsgZmkKCXNsZWVwIC4xCmRvbmUKZGV2PS9kZXYvIiR7YmRldn0i
ClsgLWIgIiR7ZGV2fSIgXQpmb3IgcncgaW4gd3JpdGUgcmFuZHdyaXRlOyBkbwogICAgc3Rh
cnRfdHJhY2luZwogICAgcGFyYW1zPSgKCS0tZGlyZWN0PTEKCS0tZmlsZW5hbWU9IiR7ZGV2
fSIKCS0taW9kZXB0aD0iJHtxZH0iCgktLWlvZGVwdGhfYmF0Y2g9JCgoKHFkICsgMykgLyA0
KSkKCS0taW9lbmdpbmU9bGliYWlvCgktLWlvc2NoZWR1bGVyPW5vbmUKCS0tZ3RvZF9yZWR1
Y2U9MQoJLS1uYW1lPSIkKGJhc2VuYW1lICIke2Rldn0iKSIKCS0tcnVudGltZT0zMAoJLS1y
dz0iJHJ3IgoJLS10aW1lX2Jhc2VkPTEKCS0tem9uZW1vZGU9emJkCiAgICApCiAgICBmaW8g
IiR7cGFyYW1zW0BdfSIKICAgIHJjPSQ/CiAgICBlbmRfdHJhY2luZwogICAgaWYgZ3JlcCAt
YXZIICIgcmVmIDEgIiAiL3N5cy9rZXJuZWwvZGVidWcvYmxvY2svJHtiZGV2fS96b25lX3dw
bHVncyI7IHRoZW4KCWVjaG8KCWVjaG8gIkRldGVjdGVkIG9uZSBvciBtb3JlIHJlZmVyZW5j
ZSBjb3VudCBsZWFrcyEiCglicmVhawogICAgZmkKICAgIGVjaG8gJycKICAgIFsgJHJjID0g
MCBdIHx8IGJyZWFrCmRvbmUKZWNobyAwID4gL3N5cy9tb2R1bGUvc2NzaV9tb2QvcGFyYW1l
dGVycy9zY3NpX2xvZ2dpbmdfbGV2ZWwK
--------------PrnkxU3HGbPtNZ8itRnKp7On
Content-Type: text/plain; charset=UTF-8; name="test-pipelining-zoned-writes"
Content-Disposition: attachment; filename="test-pipelining-zoned-writes"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCnNldCAtZQoKcnVuX2NtZCgpIHsKICAgIGlmIFsgLXogIiRhbmRyb2lk
IiBdOyB0aGVuCglldmFsICIkMSIKICAgIGVsc2UKCWFkYiBzaGVsbCAiJDEiCiAgICBmaQp9
Cgp0cmFjaW5nX2FjdGl2ZSgpIHsKICAgIFsgIiQocnVuX2NtZCAiY2F0IC9zeXMva2VybmVs
L3RyYWNpbmcvdHJhY2luZ19vbiIpIiA9IDEgXQp9CgpzdGFydF90cmFjaW5nKCkgewogICAg
cm0gLWYgL3RtcC9ibG9jay10cmFjZS50eHQKICAgIGNtZD0iKGlmIFsgISAtZSAvc3lzL2tl
cm5lbC90cmFjaW5nL3RyYWNlIF07IHRoZW4gbW91bnQgLXQgdHJhY2VmcyBub25lIC9zeXMv
a2VybmVsL3RyYWNpbmc7IGZpICYmCgljZCAvc3lzL2tlcm5lbC90cmFjaW5nICYmCglpZiBs
c29mIC10IC9zeXMva2VybmVsL3RyYWNpbmcvdHJhY2VfcGlwZSB8IHhhcmdzIC1yIGtpbGw7
IHRoZW4gOjsgZmkgJiYKCWVjaG8gMCA+IHRyYWNpbmdfb24gJiYKCWVjaG8gbm9wID4gY3Vy
cmVudF90cmFjZXIgJiYKCWVjaG8gPiB0cmFjZSAmJgoJZWNobyAwID4gZXZlbnRzL2VuYWJs
ZSAmJgoJZWNobyAxID4gZXZlbnRzL2Jsb2NrL2VuYWJsZSAmJgoJZWNobyAwID4gZXZlbnRz
L2Jsb2NrL2Jsb2NrX2RpcnR5X2J1ZmZlci9lbmFibGUgJiYKCWVjaG8gMCA+IGV2ZW50cy9i
bG9jay9ibG9ja190b3VjaF9idWZmZXIvZW5hYmxlICYmCglpZiBbIC1lIGV2ZW50cy9udWxs
YiBdOyB0aGVuIGVjaG8gMSA+IGV2ZW50cy9udWxsYi9lbmFibGU7IGZpICYmCgllY2hvIDEg
PiB0cmFjaW5nX29uICYmCgljYXQgdHJhY2VfcGlwZSkiCiAgICBydW5fY21kICIkY21kIiA+
Ii90bXAvYmxvY2stdHJhY2UtJDEudHh0IiAmCiAgICB0cmFjaW5nX3BpZD0kIQogICAgd2hp
bGUgISB0cmFjaW5nX2FjdGl2ZTsgZG8KCXNsZWVwIC4xCiAgICBkb25lCn0KCmVuZF90cmFj
aW5nKCkgewogICAgc2xlZXAgNQogICAgaWYgWyAtbiAiJHRyYWNpbmdfcGlkIiBdOyB0aGVu
IGtpbGwgIiR0cmFjaW5nX3BpZCI7IGZpCiAgICBydW5fY21kICJjZCAvc3lzL2tlcm5lbC90
cmFjaW5nICYmCglpZiBsc29mIC10IC9zeXMva2VybmVsL3RyYWNpbmcvdHJhY2VfcGlwZSB8
IHhhcmdzIC1yIGtpbGw7IHRoZW4gOjsgZmkgJiYKCWVjaG8gMCA+L3N5cy9rZXJuZWwvdHJh
Y2luZy90cmFjaW5nX29uIgp9CgphbmRyb2lkPQpmYXN0ZXN0X2NwdWNvcmU9CnRyYWNpbmc9
Cgp3aGlsZSBbICIkezEjLX0iICE9ICIkMSIgXTsgZG8KICAgIGNhc2UgIiQxIiBpbgoJLWEp
CgkgICAgYW5kcm9pZD10cnVlOyBzaGlmdDs7CgktdCkKCSAgICB0cmFjaW5nPXRydWU7IHNo
aWZ0OzsKCSopCgkgICAgdXNhZ2U7OwogICAgZXNhYwpkb25lCgpzZXQgLXUKCmlmIFsgLW4g
IiR7YW5kcm9pZH0iIF07IHRoZW4KICAgIGFkYiByb290IDE+JjIKICAgIGFkYiBwdXNoIH4v
c29mdHdhcmUvZmlvL2ZpbyAvdG1wID4mL2Rldi9udWxsCiAgICBhZGIgcHVzaCB+L3NvZnR3
YXJlL3V0aWwtbGludXgvYmxrem9uZSAvdG1wID4mL2Rldi9udWxsCiAgICBmYXN0ZXN0X2Nw
dWNvcmU9JChhZGIgc2hlbGwgJ2dyZXAgLWFIIC4gL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUv
Y3B1WzAtOV0qL2NwdWZyZXEvY3B1aW5mb19tYXhfZnJlcSAyPi9kZXYvbnVsbCcgfAoJCSAg
ICAgIHNlZCAncy86LyAvJyB8CgkJICAgICAgc29ydCAtcm5rMiB8CgkJICAgICAgaGVhZCAt
bjEgfAoJCSAgICAgIHNlZCAtZSAnc3wvc3lzL2RldmljZXMvc3lzdGVtL2NwdS9jcHV8fDtz
fC9jcHVmcmVxLip8fCcpCiAgICBpZiBbIC16ICIkZmFzdGVzdF9jcHVjb3JlIiBdOyB0aGVu
CglmYXN0ZXN0X2NwdWNvcmU9JCgoJChhZGIgc2hlbGwgbnByb2MpIC0gMSkpCiAgICBmaQog
ICAgWyAtbiAiJGZhc3Rlc3RfY3B1Y29yZSIgXQpmaQoKZm9yIG1vZGUgaW4gIm5vbmUgMCIg
Im5vbmUgMSIgIm1xLWRlYWRsaW5lIDAiICJtcS1kZWFkbGluZSAxIjsgZG8KICAgIGZvciBk
IGluIC9zeXMva2VybmVsL2NvbmZpZy9udWxsYi8qOyBkbwoJaWYgWyAtZCAiJGQiIF0gJiYg
cm1kaXIgIiRkIjsgdGhlbiA6OyBmaQogICAgZG9uZQogICAgcmVhZCAtciBpb3NjaGVkIHBy
ZXNlcnZlc193cml0ZV9vcmRlciA8PDwiJG1vZGUiCiAgICBlY2hvICI9PT09IGlvc2NoZWQ9
JGlvc2NoZWQgcHJlc2VydmVzX3dyaXRlX29yZGVyPSRwcmVzZXJ2ZXNfd3JpdGVfb3JkZXIi
CiAgICBpZiBbIC16ICIkYW5kcm9pZCIgXTsgdGhlbgoJaWYgdHJ1ZTsgdGhlbgoJICAgIGlm
IG1vZHByb2JlIC1yIHNjc2lfZGVidWc7IHRoZW4gOjsgZmkKCSAgICBwYXJhbXM9KAoJCW5k
ZWxheT0xMDAwMDAgICAgICAgICAgICAjIDEwMCB1cwoJCWhvc3RfbWF4X3F1ZXVlPTY0CgkJ
cHJlc2VydmVzX3dyaXRlX29yZGVyPSIke3ByZXNlcnZlc193cml0ZV9vcmRlcn0iCgkJZGV2
X3NpemVfbWI9MTAyNCAgICAgICAgICMgMSBHaUIKCQlzdWJtaXRfcXVldWVzPSIkKG5wcm9j
KSIKCQl6b25lX3NpemVfbWI9MSAgICAgICAgICAgIyAxIE1pQgoJCXpvbmVfbnJfY29udj0w
CgkJemJjPTIKCSAgICApCgkgICAgbW9kcHJvYmUgc2NzaV9kZWJ1ZyAiJHtwYXJhbXNbQF19
IgoJICAgIHVkZXZhZG0gc2V0dGxlCgkgICAgZGV2PS9kZXYvJChjZCAvc3lzL2J1cy9wc2V1
ZG8vZHJpdmVycy9zY3NpX2RlYnVnL2FkYXB0ZXIqL2hvc3QqL3RhcmdldCovKi9ibG9jayAm
JiBlY2hvICopCgkgICAgYmFzZW5hbWU9JChiYXNlbmFtZSAiJHtkZXZ9IikKCWVsc2UKCSAg
ICBpZiBtb2Rwcm9iZSAtciBudWxsX2JsazsgdGhlbiA6OyBmaQoJICAgIG1vZHByb2JlIG51
bGxfYmxrIG5yX2RldmljZXM9MAoJICAgICgKCQljZCAvc3lzL2tlcm5lbC9jb25maWcvbnVs
bGIKCQlta2RpciBudWxsYjAKCQljZCBudWxsYjAKCQlwYXJhbXM9KAoJCSAgICBjb21wbGV0
aW9uX25zZWM9MTAwMDAwICAgIyAxMDAgdXMKCQkgICAgaHdfcXVldWVfZGVwdGg9NjQKCQkg
ICAgaXJxbW9kZT0yICAgICAgICAgICAgICAgICMgTlVMTF9JUlFfVElNRVIKCQkgICAgbWF4
X3NlY3RvcnM9JCgoNDA5Ni81MTIpKQoJCSAgICBtZW1vcnlfYmFja2VkPTEKCQkgICAgcHJl
c2VydmVzX3dyaXRlX29yZGVyPSIke3ByZXNlcnZlc193cml0ZV9vcmRlcn0iCgkJICAgIHNp
emU9MSAgICAgICAgICAgICAgICAgICAjIDEgR2lCCgkJICAgIHN1Ym1pdF9xdWV1ZXM9IiQo
bnByb2MpIgoJCSAgICB6b25lX3NpemU9MSAgICAgICAgICAgICAgIyAxIE1pQgoJCSAgICB6
b25lZD0xCgkJICAgIHBvd2VyPTEKCQkpCgkJZm9yIHAgaW4gIiR7cGFyYW1zW0BdfSI7IGRv
CgkJICAgIGlmICEgZWNobyAiJHtwLy8qPX0iID4gIiR7cC8vPSp9IjsgdGhlbgoJCQllY2hv
ICIkcCIKCQkJZXhpdCAxCgkJICAgIGZpCgkJZG9uZQoJICAgICkKCSAgICBiYXNlbmFtZT1u
dWxsYjAKCSAgICBkZXY9L2Rldi8ke2Jhc2VuYW1lfQoJICAgIHVkZXZhZG0gc2V0dGxlCglm
aQoJWyAtYiAiJHtkZXZ9IiBdCiAgICBlbHNlCgkjIFJldHJpZXZlIHRoZSBkZXZpY2UgbmFt
ZSBhc3NpZ25lZCB0byB0aGUgem9uZWQgbG9naWNhbCB1bml0LgoJYmFzZW5hbWU9JChhZGIg
c2hlbGwgZ3JlcCAtbHZ3IDAgL3N5cy9jbGFzcy9ibG9jay9zZCovcXVldWUvY2h1bmtfc2Vj
dG9ycyAyPi9kZXYvbnVsbCB8CgkJCSAgICAgc2VkICdzfC9zeXMvY2xhc3MvYmxvY2svfHxn
O3N8L3F1ZXVlL2NodW5rX3NlY3RvcnN8fGcnKQoJIyBEaXNhYmxlIGJsb2NrIGxheWVyIHJl
cXVlc3QgbWVyZ2luZy4KCWRldj0iL2Rldi9ibG9jay8ke2Jhc2VuYW1lfSIKICAgIGZpCiAg
ICBydW5fY21kICJlY2hvIDQwOTYgPiAvc3lzL2NsYXNzL2Jsb2NrLyR7YmFzZW5hbWV9L3F1
ZXVlL21heF9zZWN0b3JzX2tiIgogICAgIyAwOiBkaXNhYmxlIEkvTyBzdGF0aXN0aWNzCiAg
ICBydW5fY21kICJlY2hvIDAgPiAvc3lzL2NsYXNzL2Jsb2NrLyR7YmFzZW5hbWV9L3F1ZXVl
L2lvc3RhdHMiCiAgICAjIDI6IGRvIG5vdCBhdHRlbXB0IGFueSBtZXJnZXMKICAgIHJ1bl9j
bWQgImVjaG8gMiA+IC9zeXMvY2xhc3MvYmxvY2svJHtiYXNlbmFtZX0vcXVldWUvbm9tZXJn
ZXMiCiAgICAjIDI6IGNvbXBsZXRlIG9uIHRoZSByZXF1ZXN0aW5nIENQVQogICAgcnVuX2Nt
ZCAiZWNobyAyID4gL3N5cy9jbGFzcy9ibG9jay8ke2Jhc2VuYW1lfS9xdWV1ZS9ycV9hZmZp
bml0eSIKICAgIGlmIFsgLW4gIiR7dHJhY2luZ30iIF07IHRoZW4KCXN0YXJ0X3RyYWNpbmcg
IiR7aW9zY2hlZH0tJHtwcmVzZXJ2ZXNfd3JpdGVfb3JkZXJ9IgogICAgZmkKICAgIHBhcmFt
czE9KAoJLS1uYW1lPXRyaW0KCS0tZmlsZW5hbWU9IiR7ZGV2fSIKCS0tZGlyZWN0PTEKCS0t
ZW5kX2ZzeW5jPTEKCS0taW9lbmdpbmU9cHZzeW5jCgktLWd0b2RfcmVkdWNlPTEKCS0tcnc9
dHJpbQoJLS1zaXplPTEwMCUKCS0tdGhyZWFkPTEKCS0tem9uZW1vZGU9emJkCiAgICApCiAg
ICBwYXJhbXMyPSgKCS0tbmFtZT1tZWFzdXJlLWlvcHMKCS0tZmlsZW5hbWU9IiR7ZGV2fSIK
CS0tZGlyZWN0PTEKCS0taW9zY2hlZHVsZXI9IiR7aW9zY2hlZH0iCgktLWd0b2RfcmVkdWNl
PTEKCS0tcnVudGltZT0zMAoJLS1ydz13cml0ZQoJLS10aHJlYWQ9MQoJLS10aW1lX2Jhc2Vk
PTEKCS0tem9uZW1vZGU9emJkCiAgICApCiAgICBpZiBbIC1uICIkZmFzdGVzdF9jcHVjb3Jl
IiBdOyB0aGVuCglmaW9fYXJncys9KC0tY3B1c19hbGxvd2VkPSIke2Zhc3Rlc3RfY3B1Y29y
ZX0iKQogICAgZmkKICAgIGlmIFsgIiRwcmVzZXJ2ZXNfd3JpdGVfb3JkZXIiID0gMSBdOyB0
aGVuCglwYXJhbXMyKz0oCgkgICAgLS1pb2VuZ2luZT1saWJhaW8KCSAgICAtLWlvZGVwdGg9
NjQKCSAgICAtLWlvZGVwdGhfYmF0Y2g9MTYKCSkKICAgIGVsc2UKCXBhcmFtczIrPSgKCSAg
ICAtLWlvZW5naW5lPXB2c3luYzIKCSkKICAgIGZpCiAgICBzZXQgK2UKICAgIGVjaG8gImZp
byAke3BhcmFtczJbKl19IgogICAgIyBGaW5pc2ggYWxsIG9wZW4gem9uZXMgdG8gcHJldmVu
dCB0aGF0IHRoZSBtYXhpbXVtIG51bWJlciBvZiBvcGVuIHpvbmVzIGlzCiAgICAjIGV4Y2Vl
ZGVkLiBOZXh0LCB0cmltIGFsbCB6b25lcyBhbmQgbWVhc3VyZSBJT1BTLgogICAgaWYgWyAt
eiAiJGFuZHJvaWQiIF07IHRoZW4KCWJsa3pvbmUgZmluaXNoICIke2Rldn0iCglmaW8gIiR7
cGFyYW1zMVtAXX0iID4iL3RtcC9maW8tdHJpbS0ke2lvc2NoZWR9LSR7cHJlc2VydmVzX3dy
aXRlX29yZGVyfS50eHQiCglmaW8gIiR7cGFyYW1zMltAXX0iCiAgICBlbHNlCglhZGIgc2hl
bGwgL3RtcC9ibGt6b25lIGZpbmlzaCAiJHtkZXZ9IgoJYWRiIHNoZWxsIC90bXAvZmlvICIk
e3BhcmFtczFbQF19IiA+L2Rldi9udWxsCglhZGIgc2hlbGwgL3RtcC9maW8gIiR7cGFyYW1z
MltAXX0iCiAgICBmaQogICAgcmV0PSQ/CiAgICBzZXQgLWUKICAgIGlmIFsgLW4gIiR7dHJh
Y2luZ30iIF07IHRoZW4KCWVuZF90cmFjaW5nCiAgICBmaQogICAgWyAiJHJldCIgPSAwIF0g
fHwgYnJlYWsKZG9uZQo=

--------------PrnkxU3HGbPtNZ8itRnKp7On--
