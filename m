Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A49299A81
	for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2025 08:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764317542; cv=none; b=JBO079X+/pVISx86zp0BwD5bC8bjq5R4DLl6hUZVEalnyjhO7KdnW8N3WFiaSmqmX5oue9W3yqUQslko8JEgPYrPuVoNtdBWcRvcBb/SYAI50fkYhnkDlu4wkhifyR/I3Wf8LvjDebkO+2Ay7r2gXo9aMJTKFSqKbCynJk2NSt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764317542; c=relaxed/simple;
	bh=3R7CHDNtZbr+bCbjgtRQNIbTl5JiEn9vVnZTt2rUUlA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=kN8KHwFnvD1M6VMYypz/tnAbEwtqCucPaDf5nE1FePEgppX+aDvoLYcpOmemJsxUCkksWXjexjUs76d5FRtC93GEvjMk8Ot9+3kf4bbZG79cT4X6VYc1CqbzX32QTf0RaZwmMa5/QhTBREXcPaKT1ipuU5+qWnMFL9NvmEHoOlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-63f96d5038dso1309473d50.1
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2025 00:12:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764317540; x=1764922340;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3R7CHDNtZbr+bCbjgtRQNIbTl5JiEn9vVnZTt2rUUlA=;
        b=YNbwF9JHumekBs+C9KEBlUNOJqHkls+PrL22aV+QJIBGCMsRtPAo+LigVdveyLd1qI
         ZDH7rduJkloMWMquECRoHq4JJ/zdIZ5r9pt4a0FhJ8iEw0MVGh28WrxrhWCjq7w+wLn6
         vG0fbvR2qRA5+SXd3jCsGib5ReCItW2+53ZQb4NheKeue/0j4aInmHV53P22FRoloA/m
         PSM9cKwbDx8xTkNnpKIAEiQnjhw2E41Oh04EXn7REXkvx8o0ENZIqDOVTym2elmP2k3f
         Xu1JF9azBO8Bt+t/PDDfKzauL4GIP/JPEhbe7LVAjiL8+VW6YCwtw6NMxKh2ArwjEuxL
         t9dA==
X-Forwarded-Encrypted: i=1; AJvYcCW2dZ+vSJmDdMw6N2L4EIkP7zwxEZ+aCIj9lg9acJgh4avZoe97RfsvHVxfrGpl8wKf3CeZDezniyFG@vger.kernel.org
X-Gm-Message-State: AOJu0YzmBd6Vs7u9Tfk5gyemsOzgp6H25BdXCqLAi7wNPJfFzUXD/o4y
	zz5MNuGOrYSAem6BPIHQiuJ2Jzd1luYD8Id5q7YB9Ba3xNJeGWAO3ztdcRTRlw==
X-Gm-Gg: ASbGncuqN9H6MySeBUDLyH+Yrc4t/GC4trNxZa10U4J8i+n727J85V+OKGkLpidIEkc
	bsPjoFyBSQn3MQYJvsAW1V80BKS2K6TccM23LIHXib/TemaOpWOtmW8FwfhWj9wPLwDsz5hpdv6
	gTOprwnHwBQ0JQwvnCxeTOqDCHo5uIyJCoK3JvvXkFYMkcu31DjXzEzwKCK1NwU2GwnYMUwwkJt
	1jY9ezegJft7xuPnKSExVhWm2c1SJBIWrgwwVCO9yUTsvuommdbVH6tKk3vj13/CEqirXzQrd5Y
	uYrJCEYDJlvIZII686zYYz+CQVxcfhc2vd8T1mfIRunClub1sLUaO96YJ67asKJ+OVFd4vzMyC1
	L/rkXWeyWD17Fp8CfAQNatIvwjpaY3IgSEAY9yxxPEPrvoPel7Jz291HMxr+tWSEV1yVXVCfyPE
	9UNoGbyqQyrx7bFf8LezXBgkXtdpbC53bNETl4s/OEXQ==
X-Google-Smtp-Source: AGHT+IG1XFcMByAvrtzSb6hnVqrUOxaB5/qhIuxYdgaZhSoVWrQbnxMrNjCg25KuWJ5VXu6QtLIPQA==
X-Received: by 2002:a05:690c:61c6:b0:786:4fd5:e5dc with SMTP id 00721157ae682-78a8b53925emr206705707b3.36.1764317540022;
        Fri, 28 Nov 2025 00:12:20 -0800 (PST)
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com. [74.125.224.49])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78ad0d5fe10sm13210127b3.14.2025.11.28.00.12.17
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Nov 2025 00:12:18 -0800 (PST)
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-6420dc2e5feso1248796d50.3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2025 00:12:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX5l0/tk85BlHKSlZDYamPCk1H4nfNAngR2b1YdqxjXmD5H5ZxGr91IlLze7GXXTFaOFHO/pA8RkYhg@vger.kernel.org
X-Received: by 2002:a53:b849:0:b0:641:f5bc:6974 with SMTP id
 956f58d0204a3-64302b07fc0mr13984609d50.80.1764317537329; Fri, 28 Nov 2025
 00:12:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Roger Shimizu <rosh@debian.org>
Date: Fri, 28 Nov 2025 00:12:06 -0800
X-Gmail-Original-Message-ID: <CAEQ9gE=Yo71Aji02a5uGdv7uZ+fJcCa1TKAEZskdM_-VZedTqQ@mail.gmail.com>
X-Gm-Features: AWmQ_bk9mUOYDVvJsIJ-Igzmxt3pBF4ab5z7MoUIMi7oStLCrWuz5qTdSoPTnCo
Message-ID: <CAEQ9gE=Yo71Aji02a5uGdv7uZ+fJcCa1TKAEZskdM_-VZedTqQ@mail.gmail.com>
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved request
To: mani@kernel.org, Bart Van Assche <bvanassche@acm.org>
Cc: James.Bottomley@hansenpartnership.com, adrian.hunter@intel.com, 
	avri.altman@sandisk.com, beanhuo@micron.com, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, peter.wang@mediatek.com, quic_nguyenb@quicinc.com, 
	Hongyang Zhao <hongyang.zhao@thundersoft.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 27 Nov 2025 22:29:35 +0530, Manivannan Sadhasivam wrote:
> On Fri, Oct 31, 2025 at 01:39:29PM -0700, Bart Van Assche wrote:
>> Instead of letting the SCSI core allocate hba->nutrs - 1 commands, let
>> the SCSI core allocate hba->nutrs commands, set the number of reserved
>> tags to 1 and use the reserved tag for device management commands. This
>> patch changes the 'reserved slot' from hba->nutrs - 1 into 0 because
>> the block layer reserves the smallest tags for reserved commands.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>
> While the issue introduced by this patch was fixed in [1], this patch (and the
> fix) somehow prevents mounting rootfs on Qcom RB3Gen2 board. The UFS partitions
> are detected, but rootfs is not getting mounted and the boot just got stuck.

While testing Rubik Pi 3 [2], I found the above UFS issue, too.
for next-20251121, I used the revert cmd below to workaround:
$ git revert 7ff1cca -m 1

for next-20251128, I used cmd below, and there's a conflict to resolve.
$ git revert f10ce81 -m 1

> If I revert this patch, together with the dependencies, rootfs is getting
> mounted properly.

Can you tell the commit list that needs to revert?

This UFS issue is quite annoying, and difficult to bisect.
Hope it gets resolved before 6.18. Thank you!

-Roger

[1] https://lore.kernel.org/linux-scsi/20251114193406.3097237-1-bvanassche@acm.org/
[2] https://lore.kernel.org/all/20251126-rubikpi-next-20251125-v7-0-e46095b80529@thundersoft.com/
