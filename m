From: "Matthew Jacob" <lydianconcepts@gmail.com>
Subject: Re: [Scst-devel] Problems with SCST and QLA 2432 FC Cards
Date: Fri, 18 May 2007 07:28:31 -0700
Message-ID: <7579f7fb0705180728m5095d81ejc78a9759830bda1a@mail.gmail.com>
References: <88044fc70705171348l64913b26r742718986632f3ca@mail.gmail.com>
	 <464D5074.3080601@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.226]:51676 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbXERO2e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 May 2007 10:28:34 -0400
Received: by nz-out-0506.google.com with SMTP id r28so1352267nza
        for <linux-scsi@vger.kernel.org>; Fri, 18 May 2007 07:28:34 -0700 (PDT)
In-Reply-To: <464D5074.3080601@vlnb.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: sandip shete <sandipshete@gmail.com>, scst-devel@lists.sourceforge.net, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

>
> Unfortunately, 24xx+ cards have very different interface, so add support
> for them is almost the same as write another driver.

 Not completely- but close. Feel free to grab

ftp://ftp.feral.com/pub/isp/isp_dist.tgz

as an example for code to add to scst.
