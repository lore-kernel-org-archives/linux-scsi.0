Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793363652;
	b=oAlyIgDzvmi7308QYXcxfaRlIfzRdrMcDpSzzXcQ/+BqtJKzNDlhkFSZAA1o/6fehK1T
	 nOX8n1UDo16cF+BQiaA2FpPsjcb75oQkbZTe4D01tHqJD2eBUv2LK5XJYEmn55IQAJS21
	 ey0iCH+Gg+gm/KvEyqmvKmDRKJIVxEAdkQuDy7jWIg1YfvoDsgFeQaDdbprrzzK4cqazY
	 T7sDE3xmn/7vjaAPjPdrjkWD1E/nMtWpIwy0ZrivHulUDSDH+760WIwugyaNip7BCYZnN
	 U6UV96K4GfrJMeCEDHBcWJN6GZBOzuLPK8NcgM3Mkg9PU6Fywxy6F3FmKgQfV9pK13Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793363652;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=WhO2XispuG63y6vI8Up/ST3FM6vVbr7Lmjvw9Ig2I+g=;
	b=0uDBNQMoiSTtmqcj0edoitC1Mi+cI+taVo+nB63g36ujzO7dqHb4sScZV27VF7chv6YB
	 gxhb56XNYsLltBt0PJDtQBvKeV8lG9ZZZy93PTT6GVRnlXf9ZgKrTzC7hrhdDohZoS87v
	 tVSNXtOR0PZp8I28nk+PsNAtn4J4GZrZSaaK75rY6bgQc+0y4mFwEDl6kJVPCTn+B+rPb
	 jqoPboLKNHQA+8PwBxX5M/S69jblB7FPPytrmioRxoRYSJTyHsmATBM16FkLNQeOM5WeO
	 +WNdbQKk0SMqcuhzuZVXD/OPuswJuCur6N7PcQ+Rb/5FwvJgjbzRBJNr24BKc3+pYRw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=flipper.net;
	spf=pass smtp.mailfrom=flipper.net;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA17B606A32A
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 12:34:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA17B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c418e215671so79329066b.0
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 05:34:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793363645; cv=none;
        d=google.com; s=arc-20260327;
        b=XrGIWSW/lS1t2yIWZWvkNxszCOPoYB6anCQ7wSUoXd8pwgrpCQqlnV+NwBH1gSnezZ
         KplmSFek4y0R9gL+QdRML0sDifzeytaseithNbboGkDZX++r0kFi21Clp82YPfjEen9Y
         jiKjLzZM4uBKTbEgGJnoqE3WrRCbx5SboDDbhjTSgYwJyjGQR4LaLfDRTW/OxPynmSzT
         Gml59nPFQycYRfgv3OFhuEmD7PSI08DesIDTBeyAozFQTdSsojMg0NZHRpEaqmFmxBWx
         d+xUpLTAVafhD5tagxJpMwHYri1l/zR1nMlru6ntxrOPXDUrFQ7V96Z277BsFueahpmJ
         PVdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WhO2XispuG63y6vI8Up/ST3FM6vVbr7Lmjvw9Ig2I+g=;
        fh=wU/GKMHI3+N/tc0cldY3+ZPEhImNyxmLjy+BSADDbQs=;
        b=VqzpeJbIJtrTYlUPdW0X00UwEa+ICixkCFTs5uHNJ6G9OQKMbNUbhOXkVJZG8ARmkf
         ckqgXomSzOr3YA5r50jAL2SZ1nqBDVzrYMG+une8gv4f8KYk1/nc+3V4Z6Z2Ayp9JH/M
         DHly+Y0jzbBUoX/KI0jYdRVxF07uUBjo48pLA9vlzEOKrWSqx2Cbmhl0L8VyTcZ8wb3W
         hldlc4OWwCutcDwk3eEowzOfMXYcgCMUBrqjJTkaVA0PMfEVK48G/4hyrKxTgHCDLZ/I
         UhRFXlV3+hafKP66vmfCqd3cy6+qba5i8ZeVLkEWoxz+kY7hI34tYmK3/FlIbvNIjjSl
         3GjQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1793363645; x=1793968445; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WhO2XispuG63y6vI8Up/ST3FM6vVbr7Lmjvw9Ig2I+g=;
        b=3x3Wo88MBsPiYHKjXR9VEC1SiuizJdgLxy1RcgaUT98mgU/ljHgXh7qbrN4bIq7uD+
         ULsn5wWjBk+O6QwdX9ikQvdX7xsnioEc3b5hC0LEx3ERlVsYZ4+8z30zSo7Q/gXILQiO
         eyNv0D+/ctiouJd/siqi9lbQYZ/+S4APrMCr/c/F94bNeYLNbLfSno7XxlKfgEhvlAp9
         2MvlSvGV44mgZC73iWWOv2xapEHXXANTBD58E+QI4YI5qL7gSJtmvFNpK5DrtF4nts3k
         OqTGMfX2HQOVFfeBkS6fmBDW8Pw6RrJXwHaZfqTkLAJDYfEEsb3+enN2+gX4vFH83DL9
         FpwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793363645; x=1793968445;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WhO2XispuG63y6vI8Up/ST3FM6vVbr7Lmjvw9Ig2I+g=;
        b=n/jKT4FqEEHVEePhYE1dfZoVuCaRN+EMtlCSuG3kMrsMV7+XWJvuBLbI7fEGLs5N+5
         qf5rh3Dza05Y6E0FKryzwiVf7iv0ezMypm9Sqyg/JV5TDStKmnpyHhX6P7k22rDkmU9R
         UGLTFEBfBVadet3kFbK8Mu3BBd5XOsY9QNJoLKZat3RQxcFa9UE4rcJZl0+wCro+gISr
         rbOa/UcJpCho1cMqRSdpJbDDf4vifErza3jZxPXAZQkh239LD46gXzGbTTv9hbBDZ/IW
         v46DbiT7eYVDKKIARmit8Qxww/Q7RLzJG3EQhpmISslN83kiOOWnbpGarZO8ZbmcrBWU
         y7MQ==
X-Forwarded-Encrypted: i=1; AKwUvBw2ChaovWxGiaf2ufadVuRB8GltMM333m/w8jyJzfg6zHPuDIwS6uVw+yeW4UO9jYmJI8pND81hQtvi@vger.kernel.org
X-Gm-Message-State: AFq9FYJxacTTl4AxSqo+vYawXdMxFnBlGNaBmiNLVZ2y5VJDse/aquyu
	p8D+IKFiwnKimadYyb7B4v+mzZTHTlfDrApALj/wW9PdxVry9+95pppn3+ExEMQ1lhSL9E3EtN6
	0KBHrefkqSoQxekl95oDBISDqk/8fwT5miZ8QGNJFNw==
X-Gm-Gg: AYBFou1GLHOyVNE07klrMdXF9XfzldU9Hcf2eaKk1bxSme/4DkDPlHQtlj7pvSTo1TU
	rWvDljWK3vUOveawN0ZAYVqy/iDqMPn9vM5btF5gHG2t5pbYQTtlZEkU33u9MNunGhtwZ/CmbO6
	x+zwzDvTW+EPDMWQ4T0vq2Ef4VDbbipDPxZBHUkUjScsVAS5Z70K5CrJJ7QTsEIV5x3h/G7yeLi
	pDvq2yw7vbQUn/Gzt610gu+GDUMc0bIiZgGRgvtYnC22FWsCtwhG+HuWLukvi/iGlUG5oLMSOQ9
	e2bdqZ6JDsJ3omqiBBbx5Ezta3Vi4IdLBvJw3xC0YGQTshiyitwimLix18l1vCBNDJwW5V9ns6d
	UGkYogWbk7Kgb/LL4ZWNZ4Z/ZmbVJPnPLI/82NU+8M4637edt5nOVbO1HvJuqcFUpEvLw5g==
X-Received: by 2002:a17:907:60c8:b0:c49:a4b1:9cb1 with SMTP id
 a640c23a62f3a-c4ca795fa50mr235275666b.3.1793363645151; Fri, 30 Oct 2026
 05:34:05 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029-biwin-tua-quirk-v2-1-4d71af956ac5@flipper.net> <e9ada0a2-aa36-4cde-a7b7-5d4693d372ae@acm.org>
In-Reply-To: <e9ada0a2-aa36-4cde-a7b7-5d4693d372ae@acm.org>
From: Alexey Charkov <alchark@flipper.net>
Date: Fri, 30 Oct 2026 16:33:57 +0400
X-Gm-Features: AclHuK8mCiMIJSS5TVbq3bssLQ6wBY5LSL7g722rlXFx8SMXsDwvAIAeegWVCKo
Message-ID: <CAKTNdwGqaTMLK7KYcdayDUuJi8NnA3rR9faqMa5CF1aOOiaY7A@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: core: Clear power-on UNIT ATTENTION on BIWIN UFS devices
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 9:20=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 10/29/26 3:41 AM, Alexey Charkov wrote:
> > The SCSI core retries a command that receives a UNIT ATTENTION and reli=
es
> > on the device to clear the condition once reported. The BIWIN
> > BWU2A0526B128G and BWU2A0516B064G UFS devices do not clear a power on o=
r
> > reset UNIT ATTENTION when reporting it to a WRITE. After a device reset=
,
> > such as on resume with the UFS link off or in UFS error recovery, write=
s
> > then fail on every retry for the full 180s retry window and end in I/O
> > errors. A TEST UNIT READY or READ clears it.
>
> Does the attached untested patch help?

Hi Bart,

Thanks a lot for this! I've tested it on five boards: three with BIWIN
UFS (BWU2A0526B128G x2, BWU2A0516B064G) and two with FORESEE C2G071,
on next-20261027. Tests: UFS error-handler resets under light writes
and under fio keeping 128 direct writes outstanding, runtime PM with a
WRITE as the first command after resume, and suspend to RAM.

The core idea works well: on the BIWIN devices the TEST UNIT READY
from the error handler clears the stuck UNIT ATTENTION about 50ms
after the reset, with no I/O errors, including the saturated-queue
case that broke my v2. Since the EH commands reuse the failed
command's tag, they don't need a scheduler tag. The FORESEE devices
never enter the error handler.

I did run into one regression though. The new scsi_noretry_cmd() check
in scsi_io_completion_action() is reachable for a UNIT ATTENTION on
data commands, since blk_stat stays BLK_STS_OK for them and the "Kill
remainder" path doesn't catch them. So a REQ_FAILFAST_DEV command that
happens to be the first to see a reset UA now fails instead of being
retried, on any device. I confirmed this by issuing a readahead during
a UFS reset: with your patch it failed with "I/O error ... flags
0x84700" in all 20 runs, on both the BIWIN and the FORESEE devices,
while without it the READ was retried and succeeded. With md
raid1/raid10 failfast this would mark a healthy member faulty after a
bus reset.

Dropping that term fixes it:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -849,9 +849,8 @@ static void scsi_io_completion_action(struct
scsi_cmnd *cmd, int result)
  */
  cmd->device->changed =3D 1;
  action =3D ACTION_FAIL;
- } else if (scsi_noretry_cmd(cmd) ||
-   (cmd->allowed !=3D SCSI_CMD_RETRIES_NO_LIMIT &&
-    cmd->retries > max(cmd->allowed, 3))) {
+ } else if (cmd->allowed !=3D SCSI_CMD_RETRIES_NO_LIMIT &&
+   cmd->retries > max(cmd->allowed, 3)) {
  action =3D ACTION_FAIL;
  } else {
  /* Must have been a power glitch, or a

With it, all readaheads in the same test (25 runs) were retried and
succeeded, and the error-handler, runtime PM and suspend tests above
passed on all five boards.

This keeps failfast commands on today's behaviour for UNIT ATTENTION,
so failfast WRITEs to a device like the BIWIN ones still go through
the old uncounted retry loop. Sending them through the new path as
well (dropping the scsi_noretry_cmd() exclusion in scsi_check_sense()
too) works, but then scsi_eh_flush_done_q() needs to count their EH
rounds, or a target that never clears the UA keeps them cycling
through EH with LU resets until the runtime limit. That seemed like
more than this fix needs: I'm not aware of anyone running md failfast
on UFS, and readahead is a READ, which clears the UA on these devices
anyway.

With that change:
Tested-by: Alexey Charkov <alchark@flipper.net>

Small nit: the BIWIN parts don't only clear the UA on TEST UNIT READY:
READ and SYNCHRONIZE CACHE clear it too. It's WRITE that doesn't.

Best regards,
Alexey
