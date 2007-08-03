From: "jidong xiao" <jidong.xiao@gmail.com>
Subject: Re: Is there any tool can perform a READ Capacity command?
Date: Fri, 3 Aug 2007 16:01:11 +0800
Message-ID: <4104961b0708030101p351f943cw8ece13edd7779d01@mail.gmail.com>
References: <4104961b0708020730r703557f4gf3df1dd508165a89@mail.gmail.com>
	 <yq13az2uhds.fsf@sermon.lab.mkp.net> <46B20905.6080203@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:20002 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759123AbXHCIBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2007 04:01:12 -0400
Received: by rv-out-0910.google.com with SMTP id k20so617246rvb
        for <linux-scsi@vger.kernel.org>; Fri, 03 Aug 2007 01:01:12 -0700 (PDT)
In-Reply-To: <46B20905.6080203@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

That's great, thanks.

Regards
Jason

On 8/3/07, Douglas Gilbert <dougg@torque.net> wrote:
> Martin K. Petersen wrote:
> >>>>>> "jidong" == jidong xiao <jidong.xiao@gmail.com> writes:
> >
> > jidong> I know sg_modes can help to perform a SCSI MODE SENSE command,
> > jidong> is there any tool/command that can perform a READ Capacity
> > jidong> command?
> >
> > sg_readcap
>
> In the sg3_utils package there is a COVERAGE file which
> lists the mapping between SCSI commands and the sg3_utils
> utilities that send them. [Amongst other things it is useful
> when I forget.]
>
>
> sg3_utils version 1.25 is work in progress; here is the
> ChangeLog to date:
>
> Changelog for sg3_utils-1.25 [20070728]
>  - sg_sat_set_features: new utility (actually copied from examples
>    directory); renamed examples version: sg__sat_set_features
>  - sg_dd: add oflag=sparse to step over bs*bpt number of zeros;
>    - with oflag=sparse, write last bs*bpt segment at end or after
>      error so file length of OFILE is appropriate
>    - when coe>1 then SCSI READ LONG logic remember extended block
>      length of first encountered error
>  - sg_dd, sgm_dd, sgp_dd: allow iflag=null and oflag=null both of
>    which do nothing (placeholders)
>  - sg_ses: sync with ses2r17 the r18
>  - sg_vpd: add block device characteristics VPD page
>  - sg_logs: update background scan results log page, sbc3r11
>  - place source in subversion repository
>  - convert build logic to use autotools (i.e. './configure ; make')
>    - rename this file from CHANGELOG to ChangeLog
>    - note: only utilities in main directory built by autotools
>      infrastructure; subdirectories still use hand-crafted Makefiles
>
>
> Doug Gilbert
>
>
