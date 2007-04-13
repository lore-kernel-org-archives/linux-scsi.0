From: "Joe Kappus" <joecool1029@gmail.com>
Subject: Re: [BUG] unable to handle kernel paging request at virtual address 0800000e
Date: Fri, 13 Apr 2007 15:45:29 -0400
Message-ID: <d4757e600704131245j7a045fa7sb2bca8cb8370f6d0@mail.gmail.com>
References: <4616CBF4.8020205@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:59789 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbXDMTpa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Apr 2007 15:45:30 -0400
Received: by an-out-0708.google.com with SMTP id b33so1028029ana
        for <linux-scsi@vger.kernel.org>; Fri, 13 Apr 2007 12:45:29 -0700 (PDT)
In-Reply-To: <4616CBF4.8020205@m3y3r.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

I can confirm the same oops on 2.6.20-ck1 with pktcdvd either as
module or as built-in.

I can assume perhaps this is not so much an issue with the pktcdvd
driver as it is with the libata drivers and scsi.  Beats me, I'll
leave it up to you.
