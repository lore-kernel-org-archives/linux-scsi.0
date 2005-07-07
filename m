From: Yogesh Bhanu <yogesh@gsf.de>
Subject: Re: is there going to be aic7xxx driver update
Date: Thu, 07 Jul 2005 15:39:57 +0200
Message-ID: <42CD30AD.10602@gsf.de>
References: <0882D625EC1D3043B8F0C4C3C8F73451016FC286@ntmail.gsf.de> <20050707125302.GA28489@infradead.org>
Reply-To: yogesh@gsf.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta2.gsf.de ([146.107.4.111]:29595 "EHLO mta2.gsf.de")
	by vger.kernel.org with ESMTP id S261525AbVGGNjF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2005 09:39:05 -0400
In-Reply-To: <20050707125302.GA28489@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Hi Christoph ,
                 Martin and I have already reported our issues with adaptec 
driver . His issue was with 2.4 series kernel which he fixed by using adaptec 
driver . I have issues with 2.6 kernel . Temporarily I have switched to using
LSI Controller and it seems to help . As it is my production server I cannot 
test with every kernel patch that is coming out .



here is the link to my mail which was forwarded by Andrew Morton
http://marc.theaimsgroup.com/?l=linux-scsi&m=111748746813088&w=2

I had posted my another attempt but unfortunately I cannot find the mail in 
digests .

and here is the link to Martin Mokrejs's email .
http://marc.theaimsgroup.com/?l=linux-scsi&m=111937786531131&w=2


hth
yogesh
