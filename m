From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: pm8001: [PATCH] fix missed changes during trim sas task of slow
 path change
Date: Wed, 15 Feb 2012 15:32:02 -0800
Message-ID: <CAA9_cmemGvOwDDun68_g_xFTioPQZUjjWB=TSKuG=P83=R+BKw@mail.gmail.com>
References: <E2EC78FE4D924618947E7C7FA03910BA@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42840 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2BOXcD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2012 18:32:03 -0500
Received: by vcge1 with SMTP id e1so1150190vcg.19
        for <linux-scsi@vger.kernel.org>; Wed, 15 Feb 2012 15:32:02 -0800 (PST)
In-Reply-To: <E2EC78FE4D924618947E7C7FA03910BA@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, lindar_liu@usish.com, crystal_yu@usish.com

On Tue, Feb 14, 2012 at 5:35 PM, Jack Wang <jack_wang@usish.com> wrote:
> Dan forget to change sas_alloc_task to sas_alloc_slow_task in pm8001, which
> will lead to NULL point dereference, fix this.
>
> From b93ecdd72d6eaf96bd9c1d735dac0b350a3b2bff Mon Sep 17 00:00:00 2001
> From: Jack Wang <jack_wang@usish.com>
> Date: Tue, 14 Feb 2012 08:27:52 -0500
> Subject: [PATCH] fix missed changes during trim sas task of slow path change
>
> Signed-off-by: Jack Wang <jack_wang@usish.com>

Thanks Jack, I'll fold this into the existing patch and add your Acked-by.

--
Dan
