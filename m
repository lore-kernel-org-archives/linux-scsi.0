From: Louay Gammo <lgammo@cs.uwaterloo.ca>
Subject: Re: Aic7x_x_x 6.2.36 && Aic79xx 1.3.10 Updates
Date: Thu, 13 Nov 2003 17:13:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FB401FF.7060208@cs.uwaterloo.ca>
References: <3FB3DEBD.5050306@cs.uwaterloo.ca> <235850000.1068759765@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bbcr.uwaterloo.ca ([129.97.34.2]:2538 "EHLO bbcr.uwaterloo.ca")
	by vger.kernel.org with ESMTP id S264443AbTKMWLk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 17:11:40 -0500
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

Justin T. Gibbs wrote:

>>Hi,
>>
>>Has any one succeeded in running the latest  sources with RH9 (2.4.20-8)
>>kernel? Specifically, these are the sources sent out by Justin T. Gibbs.
>>
>>    http://people.FreeBSD.org/~gibbs/linux/SRC/
>><http://people.FreeBSD.org/%7Egibbs/linux/SRC/>
>>In my case the driver loads fine, but it takes a while to initialize(?). I get errors like:
>>scsi0: Host status: Failed(0)
>>...
>>    
>>
>
>The latest source on my site is for aic7xxx 6.3.4 and aic79xx 2.0.4.
>Are you referring to these versions?  Have you tried the pre-built
>drivers for this kernel which are also on my site?
>
>--
>Justin
>  
>
I got this tarball from your website: aic79xx-linux-2.4-20031106-tar.gz. 
I untarred on top on my private 2.4.20-8 kernel tree. Should I have 
deleted the aic7xxx directory before I did this?

I did use an older version of the binary driver RPM. I faced versioning 
problems at the RPM install script level and (if I did a manual install 
of the binary in /lib/modules/2.4.20-8custom) the kernel versioning 
problem.  This driver works fine with standard RH kernels though.

I am hoping for a solution that will enable me to have a super-kernel 
that will run on multiple H/W configurations without hacking on init 
scripts. That's why I am interested in getting the driver build and 
install properly from sources.

Thanks,

L.

P.S. This info comes from the same machine when booted with stock RH 
2.4.20-8. /proc/scsi/0:

    Adaptec AIC79xx driver version: 1.3.10
    Adaptec AIC7902 Ultra320 SCSI adapter
    aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 101-133Mhz, 512 SCBs
    Allocated SCBs: 32, SG List Length: 102
    ...


