From: Simon Munton <simon@munton.demon.co.uk>
Subject: Re: PROBLEM: aic7xxx can hang PC on SMP kernel 2.4.22
Date: Fri, 7 Nov 2003 22:23:20 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311072223.20508.simon@munton.demon.co.uk>
References: <200311062109.58979.simon@munton.demon.co.uk> <1550702704.1068157553@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:22276 "EHLO
	anchor-post-35.mail.demon.net") by vger.kernel.org with ESMTP
	id S261763AbTKGWXW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 17:23:22 -0500
Received: from munton.demon.co.uk ([62.49.24.21] helo=intrepid.munton.demon.co.uk)
	by anchor-post-35.mail.demon.net with esmtp (Exim 3.35 #1)
	id 1AIF0i-0008zs-0Z
	for linux-scsi@vger.kernel.org; Fri, 07 Nov 2003 22:23:20 +0000
In-Reply-To: <1550702704.1068157553@aslan.btc.adaptec.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thursday 06 Nov 2003 10:25 pm, Justin T. Gibbs wrote:

> The attached patch should fix this for you.  It is included in the latest
> driver source that I will be uploading in a moment to my website. 

Thanks, that did fix it.

Simon


