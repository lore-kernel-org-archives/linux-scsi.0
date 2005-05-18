From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Wed, 18 May 2005 09:12:39 -0500
Message-ID: <1116425559.5027.1.camel@mulgrave>
References: <20050516085832.GA9558@gmail.com>
	 <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org>
	 <1116340465.4989.2.camel@mulgrave> <20050517170824.GA3931@in.ibm.com>
	 <1116354894.4989.42.camel@mulgrave>  <20050518090722.GA3937@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:29658 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261194AbVEROM5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2005 10:12:57 -0400
In-Reply-To: <20050518090722.GA3937@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dino@in.ibm.com
Cc: Andrew Morton <akpm@osdl.org>, gregoire.favre@gmail.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-05-18 at 14:37 +0530, Dinakar Guniguntala wrote:
> It works !! Thanks.
> 
> So are these patches getting into -mm first or -rc5 ??

Damn, I knew you were going to ask that ... the problem is it's the last
in a long line of invasive adaptec patches that sit in my scsi-misc-2.6
tree ... I suppose we can't have the aic driver slightly hosed for
2.6.12; I'll see if I can extract them.

James


