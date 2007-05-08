From: Daniel.E.Messinger@seagate.com
Subject: Re: [PATCH] bsg: fix a blocking read bug
Date: Tue, 8 May 2007 10:50:46 -0500
Message-ID: <OFC56078BE.693853FA-ON862572D5.0056E0A9-862572D5.00570C22@seagate.com>
References: <200705081321.l48DLJe4019439@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pps0.sv-ext.mailhost.seagate.com ([192.55.4.60]:59489 "EHLO
	pps0.sv-ext.mailhost.seagate.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754787AbXEHPvE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 11:51:04 -0400
In-Reply-To: <200705081321.l48DLJe4019439@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org

Thanks!   bsg now waits for a response.

Dan



                                                                           
             FUJITA Tomonori                                               
             <fujita.tomonori@                                             
             lab.ntt.co.jp>                                             To 
             No Phone Info             jens.axboe@oracle.com               
             Available                                                  cc 
                                       linux-scsi@vger.kernel.org,         
                                       Daniel.E.Messinger@seagate.com      
             05/08/2007 08:21                                      Subject 
             AM                        [PATCH] bsg: fix a blocking read    
                                       bug                                 
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           




This patch fixes a bug that read() returns ENODATA even with a
blocking file descriptor when there are no commands pending.

This also includes some cleanups.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

...


