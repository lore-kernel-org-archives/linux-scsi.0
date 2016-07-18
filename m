From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 1/3] xen-scsiback: Delete an unnecessary check before the
 function call "kfree"
Date: Mon, 18 Jul 2016 07:01:48 +0200
Message-ID: <0efb482b-8cad-9d0a-253b-5cd2f56baf1b@suse.com>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <59e51c7d-f7bb-c55f-d2fe-06dccfef6a99@users.sourceforge.net>
 <fa839c03-b076-0264-c363-5581d0298632@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fa839c03-b076-0264-c363-5581d0298632@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

On 16/07/16 22:22, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 16 Jul 2016 21:21:05 +0200
> 
> The kfree() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
