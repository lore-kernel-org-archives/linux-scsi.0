From: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch] 2.6 -- add IOI Media Bay to SCSI quirk list
Date: Thu, 12 Aug 2004 21:21:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <411C17B4.7030804@tuxdriver.com>
References: <200408122137.i7CLbGU13688@ra.tuxdriver.com> <20040812225118.GA20904@beaverton.ibm.com> <411BF6A5.2030306@tuxdriver.com> <20040813002756.GA21763@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from apollo.tuxdriver.com ([24.172.12.4]:35858 "EHLO
	ra.tuxdriver.com") by vger.kernel.org with ESMTP id S268924AbUHMBV1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 21:21:27 -0400
In-Reply-To: <20040813002756.GA21763@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Patrick Mansfield wrote:

>Only add borken devices to the list, so it is a list of bad devices rather
>than a list of good ones.
>  
>

I now see the comments about the list being deprecated.  I withdraw the 
2.6 patch.  I still think the 2.4 patch is wortwhile, unless there is an 
overhaul going-on there as well.

John
