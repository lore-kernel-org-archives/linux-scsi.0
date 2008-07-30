From: thomas schorpp <thomas.schorpp@googlemail.com>
Subject: Re: aic7xxx: aic7892(B): possible regression in 2.6.26: intermittent
 unexpected busfrees
Date: Wed, 30 Jul 2008 20:25:28 +0200
Message-ID: <4890B218.3030009@gmail.com>
References: <488DC747.9060200@gmail.com>
Reply-To: thomas.schorpp@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:29595 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbYG3SZd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 14:25:33 -0400
Received: by nf-out-0910.google.com with SMTP id d3so82699nfc.21
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jul 2008 11:25:32 -0700 (PDT)
In-Reply-To: <488DC747.9060200@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

thomas schorpp wrote:
> hi,
> 
> got dozens of intermittent bus-frees in few days with my Cheetah X15 
> since upgrading to vanilla release kernel 2.6.26.0
> 
> -did not touch the hw
> -fsck ok
> -smart short/long selftest ok
> -temperatures/voltages ok
> 
> is this the hot weather, my old adaptec 19160 hba or the on disc 
> controller dying or have You guys done some "performance" changes in 
> aic7xxx released with 2.6.26 ?

takeback. powerline voltage ribble by crappy REVOLTEC hdd fan cooler with broken 
fan bearings after 3 months on the same line as the Cheetah.

greased, changed line and all fine again, sorry that is was not software ;)

y
tom
