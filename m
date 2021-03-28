Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AD1C433C1
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Mar 2021 17:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4152E61966
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Mar 2021 17:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhC1RLr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Mar 2021 13:11:47 -0400
Received: from sender4-of-o53.zoho.com ([136.143.188.53]:21309 "EHLO
        sender4-of-o53.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbhC1RLd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Mar 2021 13:11:33 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Mar 2021 13:11:33 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1616950575; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=dWGVkMwKpuihnKzHL+C41dsZcTvJQgZzZxNhTF0Kxl7B/ezO40TBlpN/DcFydV3Kvq47GFUCewcUUM76aMSWTAqwx7BnGeLCe8YxzoGxsQWhX+d0j8v61RYSrFwPVeQnPrOcTvGKAWfqM/ttTzhFKAWm4vpPPY4CSjYQWwTvn7o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1616950575; h=Content-Type:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=mkfU47OJD2nR8Wg4aAXRn3IBVmfN4IJgJbwKAX6+Amg=; 
        b=DQwGr7SsN+jxcq6r+1dqrX4e5f0viYZLUNxPQiKc8xzMs3H0niP9PnwKtLy6AuEWx4hglqaCF5naufVlCPDrMdoTgMSmMejJ4fsTzTeRzYIKZ2iZ2FACJPUe9Rk5C91Lkk684TXm0Ihmz+0HpTBaoH9qPMqqkOCmHq2Dt+su2fs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=qubes-os.org;
        spf=pass  smtp.mailfrom=frederic.pierret@qubes-os.org;
        dmarc=pass header.from=<frederic.pierret@qubes-os.org> header.from=<frederic.pierret@qubes-os.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1616950575;
        s=s; d=qubes-os.org; i=frederic.pierret@qubes-os.org;
        h=From:To:Cc:Subject:Message-ID:Date:MIME-Version:Content-Type;
        bh=mkfU47OJD2nR8Wg4aAXRn3IBVmfN4IJgJbwKAX6+Amg=;
        b=aU8NZ1Q3IODpegu+v9e3qsCUmS6gU1V4WILT113PP3J9foZqzjiV4vhnQnWo0KM5
        KZ6RRb3aE+lu8CsghDXc8ASNtomJGnSnAH9Co4Illibbhi9lpkxptFvLeYT2whqQzXj
        eACXvuMOOanGPeSJ6DCZVUFW0cL8e0XHVzAWnO1o=
Received: from [10.137.0.21] (92.188.110.153 [92.188.110.153]) by mx.zohomail.com
        with SMTPS id 1616950572643641.362600588382; Sun, 28 Mar 2021 09:56:12 -0700 (PDT)
From:   =?UTF-8?B?RnLDqWTDqXJpYyBQaWVycmV0?= 
        <frederic.pierret@qubes-os.org>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: MegaRaid SAS 9341-8i issue
Message-ID: <ce228d78-8651-d958-d1e5-2f82cbb8113d@qubes-os.org>
Date:   Sun, 28 Mar 2021 18:56:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kkrdfa8a6BDG4W5HT4XuNFuhGZUbo4Icb"
X-Zoho-Virus-Status: 1
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kkrdfa8a6BDG4W5HT4XuNFuhGZUbo4Icb
Content-Type: multipart/mixed; boundary="UTXbqOhUa6ITV2G6eRTzLyJdTZJwNnozI";
 protected-headers="v1"
From: =?UTF-8?B?RnLDqWTDqXJpYyBQaWVycmV0?= <frederic.pierret@qubes-os.org>
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
 shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Message-ID: <ce228d78-8651-d958-d1e5-2f82cbb8113d@qubes-os.org>
Subject: MegaRaid SAS 9341-8i issue

--UTXbqOhUa6ITV2G6eRTzLyJdTZJwNnozI
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

I'm having issue with a MegaRaid 9341-8i card which is properly working o=
n two motherboards (kernel-5.10.25 and kernel-5.11.10) but not on a third=
 for which I want it to work. I originally received this card with a firm=
ware from 2018 and I've updated it to the latest from Broadcom website (2=
4.21.0-0148) but in both cases, I've the same issue on the third motherbo=
ard:

[   14.013135] megaraid_sas 0000:01:00.0: BAR:0x1  BAR's base_addr(phys):=
0x00000000fe800000  mapped virt_addr:0x(ptrval)
[   14.013142] megaraid_sas 0000:01:00.0: FW now in Ready state
[   14.013148] megaraid_sas 0000:01:00.0: 63 bit DMA mask and 32 bit cons=
istent mask
[   14.013933] megaraid_sas 0000:01:00.0: firmware supports msix        :=
 (96)
[   14.014439] megaraid_sas 0000:01:00.0: requested/available msix 5/5
[   14.014445] megaraid_sas 0000:01:00.0: current msix/online cpus      :=
 (5/4)
[   14.014447] megaraid_sas 0000:01:00.0: RDPQ mode     : (disabled)
[   14.014453] megaraid_sas 0000:01:00.0: Current firmware supports maxim=
um commands: 272        LDIO threshold: 237
[   14.014631] megaraid_sas 0000:01:00.0: Configured max firmware command=
s: 271
[   14.015377] megaraid_sas 0000:01:00.0: Performance mode :Latency
[   14.015380] megaraid_sas 0000:01:00.0: FW supports sync cache        :=
 Yes
[   14.015388] megaraid_sas 0000:01:00.0: megasas_disable_intr_fusion is =
called outbound_intr_mask:0x40000009
[   14.037098] megaraid_sas 0000:01:00.0: Init cmd return status FAILED f=
or SCSI host 2
[   14.037762] megaraid_sas 0000:01:00.0: Failed from megasas_init_fw 639=
9

Trying to rmmod then modprobe leads to something that looks like stuck st=
ate or such:

[  570.269770] megaraid_sas 0000:01:00.0: BAR:0x1  BAR's base_addr(phys):=
0x00000000fe800000  mapped virt_addr:0x00000000f42ba0e1
[  570.269775] megaraid_sas 0000:01:00.0: Waiting for FW to come to ready=
 state
[  570.269780] megaraid_sas 0000:01:00.0: FW in FAULT state, Fault code:0=
x10000 subcode:0x0 func:megasas_transition_to_ready
[  570.269782] megaraid_sas 0000:01:00.0: System Register set:
(***)
[  570.269908] megaraid_sas 0000:01:00.0: Failed to transition controller=
 to ready from megasas_init_fw!
[  570.269919] megaraid_sas 0000:01:00.0: Failed from megasas_init_fw 639=


The motherboard which is not working is a recent one: Asrock X570D4U-2L2T=
 with a Ryzen 3900XT.

I've read a lot of things on internet saying that might be CSM issues or =
such but no luck with that. On the two working motherboards, it works in =
legacy/UEFI only. I've also tested the card on a x16 or x8 slots, the sam=
e result. I've attempted to build megaraid driver provided from Broadcom =
(07.716.01.00-2). Up to a slight adjustment in a log call using older att=
ribute "host_busy", I'm hitting an unrelated issue due to KBUILD_CFLAGS r=
ecursion in arch/x86/Makefile.

After hours and hours of testing, I'm currently out of ideas. Does anyone=
 has an idea or could help me into adding useful debug info in the driver=
 or such?

Thank very much in advance,
Fr=C3=A9d=C3=A9ric


--UTXbqOhUa6ITV2G6eRTzLyJdTZJwNnozI--

--kkrdfa8a6BDG4W5HT4XuNFuhGZUbo4Icb
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEn6ZLkvlecGvyjiymSEAQtc3FduIFAmBgtSYACgkQSEAQtc3F
duKQtA/+N7jFgvkA0IK1W984kJ49NFTt+v5mAVUS5vBPesvU2ZMfRkWf8BVgDjHN
IgS4YVaIz4/DSoIldyy1LGbkAraH3pbudhTGYgogzI9QoX5sIPfzN1zOpjOW2Sjs
1OvHoGkrr7PJ77Dj1ecpnr3HR/KPo2b9D/HQ7WMSYzSqDP4eebHziynNIgGcMNK0
6rbln+59T6AZINbNFlCsjRCzy+7HV+RRE3LUprL63QRWip4RaaOmY5P5gSa17ppw
cQc8QyIMG571RYUeNCQ1/CqXv9pZSiJc1KIyrn95darYzUUtejAyM9zpBeEaZsEa
xnSOxWzlNQgjYTNpCSHaLAqgLdrA9i5nxJIDnl4H3e/YWab3Si1w1SeD1y8oxDYu
8jKcm3gTLVR6zZuEy2CpU8fCax/pbU7NKuptG0kQa5E03uEDORoPglRJR+rLCN4X
jb/nvDgSEBeVcUW6UmjwtD587IlRiTBq3C5Ng9eFlse84fkpVuRw65YQSKY4AAIT
iVVrMnsenrt2NbADQ2e35QXdibiiiBZnz3qOII4L/cUbr8RZzywG0q+N3yXGfVHW
qG1CKV9GkXaBf4VuIb/SlSjeO5PP63iq6VhMqg4z0vj2jwOV9RFbwJDYh2KJBa3m
8dzboirKYKb1ACYM/mX6A3Gt3F2KZKhhj3FRA0eq9+Y3OTv9f1k=
=ft8L
-----END PGP SIGNATURE-----

--kkrdfa8a6BDG4W5HT4XuNFuhGZUbo4Icb--
