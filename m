Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327A72B9B7;
	Sun, 27 Jul 2025 10:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753613454; cv=none; b=jSHa+8mlzxUXKF08prs6sEFp1w7hAC2WjiZOPNSZWB1VsVyHkbQ97ZlnElBJaRkYhHHxpj5PrnMTIBfBAJ3w3Phr4fqg/JiT0cjGsXhkecCABIz4rffZLdCl5pF5z+HwBEQWn6GopCWtYgi/NPgO8ugXsURsfx+XzcQ47cZypls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753613454; c=relaxed/simple;
	bh=nJJt0PWAEW7qWLJBibqep/glZnUSFIRPI0ZmD9jLzpA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G17bS8F2gOuGJFYl9RigQvceLzm1ACPgT3l9BN5GvYoo2ZUEnNeW1SozUg+/B4wtxbNlbTerhFJEoY8hbwUxFwOgfWNaG3b3wSvvDIPid69YBs+5Tc5wSatwhJakxOsY0D5iimKzHEE/ciSiRRjDVajOLBigm064BiNOVVggoxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BeMiIejR; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BeMiIejR"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-60bfcada295so5709359a12.1;
        Sun, 27 Jul 2025 03:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753613450; x=1754218250; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1k8lEaluAubMWH/68CvxHBh8kK6RARI4kO0mTJ25QH8=;
        b=BeMiIejRRTbO12Vx8oCVZwINDuFqbAIqPB6W8+PvieQgNZq4t+eX4Wzw/Bs4tixz1d
         sdUDlllF9mUiRr+Ui4MDO84gPMmdEaurtzJhqDSu+lH8qoRiAnCueB/0J0xzccZyFJJS
         Ut/BXTMMe35JwGEfh1W/RK0N6gGAgvh1hCXe3IXD98hHKfGt6wgCqVMsF+fFYm9Hezdo
         SFobJOZZq6a5fpq5TolQT6gpbAP8T8HPdzdKOPUlnbqFJNWl1kBCfdtKCzIjtVN8iZsl
         qmd9lyUhkrfrKcupVYBdcvGJQHv40wzvDajy+8ZtaYPTbqaR585WGg23F87fh4mcJV75
         ARIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753613450; x=1754218250;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1k8lEaluAubMWH/68CvxHBh8kK6RARI4kO0mTJ25QH8=;
        b=GnHvoPLm3kXE043SrAsZ5XsSaCiLfGNW02EBMubfH3dCXcpf0Qdn/W8v+q9X559bxj
         1eygaFYgL//ByBXuuX5IkyNTTWW+2JQZ1DDNuIB+S/c+HKFj1Sds+Sprcj0lidq9WWeX
         3ZYvDm9q9KFmgzpFVakIybY3a5J3mLWE6wSMQxZ8W8YhOS6JkxTdpgkz4+IkRr3z34Na
         g+pHXbRxKwC2h7oQGbPuguOPXQOnWminjcWad0gH/MSPWKlHoRN9KPPQxYlzOihAj/0i
         u/6URNIpckw8NZHT2PKB++UA+OzdZhwOCmnBqWgiFrgTYkRAA9sMQKv0rD88Gt5JyIoh
         +TXg==
X-Forwarded-Encrypted: i=1; AJvYcCWiYQHxbi2lPao2e/LUWuZZ3jDW+hbi/DKbqoyN2n72LkV3R7IVVPhoooo9+TWL7mFIUTnXdA+S6TPh@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv6fTYBJUwS6Kdk1ZBlv3h5sfNb8CLfkqz9FNO3cmDAXbxzbPa
	6+DU8Kn1clmE1XMgYbGS43PBgHNpYMmGprbezgw4oEnWATIlY6to4Fuq
X-Gm-Gg: ASbGnctsez+GRxliFChyQYH9Up9n2AIJ95nX7M1BYSrj2JGM02RikHgsJ3G092rn6nh
	oaLjUeJcJFflwbwhO4NE2eH+tA38BKpnGjPLh3rEJQAd3R/2AqfxhLJ+ToYXVfU+Ba/YBFk0EtY
	JJDrQVHZ+eReyEg+P2XVlR865P7EpIb1RvLxs6HN6ZXtVWRi2zRxEmpqkvdEjJBjhsbbAnGGQhT
	an4S6tH3tN9QCXwJXvUAJLzWHWIXO2bYYoB4V7CpAU+nBZiJrFgMDD2OW52319skITX1YuXbUui
	hG0j4VSVStkjGyhfL83LjlU3i3OARC4v0tAybWHgyC8DXSBMcZLOOidSxGQL5pxNSYPkK2kO4Ud
	0vm8tb+dXy4BrdGSsIpHFy2KD2SdXEcKxg+j30POPEtQKaqQbtJgVGng4AIgMGZvsckuCrsCbhc
	W6W8cuJ9Q0w+L8
X-Google-Smtp-Source: AGHT+IFgMX/fMwKAl4co6ltWf3TS6ljsYk5mHIgfdpSUlcZpIq0pzRFBDhzWsj9kkna1wHLSwdj+nA==
X-Received: by 2002:a05:6402:26c6:b0:615:1084:9d66 with SMTP id 4fb4d7f45d1cf-6151084dde2mr3711703a12.7.1753613450061;
        Sun, 27 Jul 2025 03:50:50 -0700 (PDT)
Received: from [192.168.72.73] (catv-188-142-181-47.catv.fixed.one.hu. [188.142.181.47])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61500aedabfsm1870111a12.60.2025.07.27.03.50.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Jul 2025 03:50:49 -0700 (PDT)
Message-ID: <bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
Date: Sun, 27 Jul 2025 12:50:48 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Improper io_opt setting for md raid5
To: Coly Li <colyli@kernel.org>, hch@lst.de
Cc: linux-block@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
Content-Language: en-US, hu
From: =?UTF-8?Q?Csord=C3=A1s_Hunor?= <csordas.hunor@gmail.com>
In-Reply-To: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Adding the SCSI maintainers because I believe the culprit is in
drivers/scsi/sd.c, and Damien Le Moal because because he has a pending
patch modifying the relevant part and he might be interested in the
implications.

On 7/15/2025 5:56 PM, Coly Li wrote:
> Let me rescript the problem I encountered.
> 1, There is an 8 disks raid5 with 64K chunk size on my machine, I observe
> /sys/block/md0/queue/optimal_io_size is very large value, which isn’t
> reasonable size IMHO.

I have come across the same problem after moving all 8 disks of a RAID6
md array from two separate SATA controllers to an mpt3sas device. In my
case, the readahead on the array became almost 4 GB:

# grep ^ /sys/block/{sda,md_helium}/queue/{optimal_io_size,read_ahead_kb}
/sys/block/sda/queue/optimal_io_size:16773120
/sys/block/sda/queue/read_ahead_kb:32760
/sys/block/md_helium/queue/optimal_io_size:4293918720
/sys/block/md_helium/queue/read_ahead_kb:4192256

Note: the readahead is supposed to be twice the optimal I/O size (after
a unit conversion). On the md array it isn't because of an overflow in
blk_apply_bdi_limits. This overflow is avoidable but basically
irrelevant; however, it nicely highlights the fact that io_opt should
really never get this large.

> 2,  It was from drivers/scsi/mpt3sas/mpt3sas_scsih.c, 
> 11939 static const struct scsi_host_template mpt3sas_driver_template = {
...
> 11960         .max_sectors                    = 32767,
...
> 11969 };
> at line 11960, max_sectors of mpt3sas driver is defined as 32767.
> 
> Then in drivers/scsi/scsi_transport_sas.c, at line 241 inside sas_host_setup(),
> shots->opt_sectors is assigned by 32767 from the following code,
> 240         if (dma_dev->dma_mask) {
> 241                 shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
> 242                                 dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
> 243         }
> 
> Then in drivers/scsi/sd.c, inside sd_revalidate_disk() from the following coce,
> 3785         /*
> 3786          * Limit default to SCSI host optimal sector limit if set. There may be
> 3787          * an impact on performance for when the size of a request exceeds this
> 3788          * host limit.
> 3789          */
> 3790         lim.io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
> 3791         if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
> 3792                 lim.io_opt = min_not_zero(lim.io_opt,
> 3793                                 logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
> 3794         }
> 
> lim.io_opt of all my sata disks attached to mpt3sas HBA are all 32767 sectors,
> because the above code block.
> 
> Then when my raid5 array sets its queue limits, because its io_opt is 64KiB*7,
> and the raid component sata hard drive has io_opt with 32767 sectors, by
> calculation in block/blk-setting.c:blk_stack_limits() at line 753,
> 753         t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
> the calculated opt_io_size of my raid5 array is more than 1GiB. It is too large.
> 
> I know the purpose of lcm_not_zero() is to get an optimized io size for both
> raid device and underlying component devices, but the resulted io_opt is bigger
> than 1 GiB that's too big.
> 
> For me, I just feel uncomfortable that using max_sectors as opt_sectors in
> sas_host_stup(), but I don't know a better way to improve. Currently I just
> modify the mpt3sas_driver_template's max_sectors from 32767 to 64, and observed
> 5~10% sequetial write performance improvement (direct io) for my raid5 devices
> by fio.

In my case, the impact was more noticable. The system seemed to work
surprisingly fine under light loads, but an increased number of
parallel I/O operations completely tanked its performance until I
set the readaheads to their expected values and gave the system some
time to recover.

I came to the same conclusion as Coly Li: io_opt ultimately gets
populated from shost->max_sectors, which (in the case of mpt3sas and
several other SCSI controllers) contains a value which is both:
- unnecessarily large for this purpose and, more importantly,
- not a nice number without any large odd divisors, as blk_stack_limits
  clearly expects.

Populating io_opt from shost->max_sectors happens via
shost->opt_sectors. This variable was introduced in commits
608128d391fa ("scsi: sd: allow max_sectors be capped at DMA optimal
size limit") and 4cbfca5f7750 ("scsi: scsi_transport_sas: cap shost
opt_sectors according to DMA optimal limit"). Despite the (in hindsight
perhaps unfortunate) name, it wasn't used to set io_opt. It was optimal
in a different sense: it was used as a (user-overridable) upper limit
to max_sectors, constraining the size of requests to play nicely with
IOMMU which might get slow with large mappings.

Commit 608128d391fa even mentions io_opt:

    It could be considered to have request queues io_opt value initially
    set at Scsi_Host.opt_sectors in __scsi_init_queue(), but that is not
    really the purpose of io_opt.

The last part is correct. shost->opt_sectors is an _upper_ bound on the
size of requests, while io_opt is used both as a sort of _lower_ bound
(in the form of readahead), and as a sort of indivisible "block size"
for I/O (by blk_stack_limits). These two existing purposes may or may
not already be too much for a single variable; adding a third one
clearly doesn't work well.

It was commit a23634644afc ("block: take io_opt and io_min into account
for max_sectors") which started setting io_opt from shost->opt_sectors.
It did so to stop abusing max_user_sectors to set max_sectors from
shost->opt_sectors, but it ended up misusing another variable for this
purpose -- perhaps due to inadvertently conflating the two "optimal"
transfer sizes, which are optimal in two very different contexts.

Interestingly, while I've verified that the increased values for io_opt
and readahead on the actual disks definitely comes from this commit
(a23634644afc), the io_opt and readahead of the md array are unaffected
until commit 9c0ba14828d6 ("blk-settings: round down io_opt to
physical_block_size") due to a weird coincidence. This commit rounds
io_opt down to the physical block size in blk_validate_limits. Without
this commit, io_opt for the disks is 16776704, which looks even worse
at first glance (512 * 32767 instead of 4096 * 4095). However, this
ends up overflowing in a funny way when combined with the fact that
blk_stack_limits (and thus lcm_not_zero) is called once per component
device:

u32 t = 3145728; // 3 MB, the optimal I/O size for the array
u32 b = 16776704; // the (incorrect) optimal I/O size of the disks
u32 x = lcm(t, b); // x == (u32)103076069376 == 4291821568
u32 y = lcm(x, b); // y == (u32)140630117318656 == t

Repeat for an even number of component devices to get the right answer
from the wrong inputs by an incorrect method.

I'm sure the issue can be reproduced before commit 9c0ba14828d6
(although I haven't actually tried -- if I had to, I'd start with an
array with an odd number of component devices), but at the same time,
the issue may be still present and hidden on some systems even after
that commit (for example, the rounding does nothing if the physical
block size is 512). This might help a little bit to explain why the
problem doesn't seem more widespread.

> So there should be something to fix. Can you take a look, or give me some hint
> to fix?
> 
> Thanks in advance.
> 
> Coly Li

I would have loved to finish with a patch here but I'm not sure what
the correct fix is. shost->opt_sectors was clearly added for a reason
and it should reach max_sectors in struct queue_limits in some way. It
probably isn't included in max_hw_sectors because it's meant to be
overridable. Apparently just setting max_sectors causes problems, and
so does setting max_sectors and max_user_sectors. I don't know how to
to fix this correctly without introducing a new variable to struct
queue_limits but maybe people more familiar with the code can think of
a less intrusive way.

Hunor Csordás

