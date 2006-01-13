From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 6/10] iscsi: seperate iscsi interface from setup functions
Date: Fri, 13 Jan 2006 13:25:58 -0600
Message-ID: <43C7FEC6.70900@cs.wisc.edu>
References: <1137128919.9508.39.camel@max> <20060113181755.GO20718@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59570 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1422836AbWAMT0G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 14:26:06 -0500
In-Reply-To: <20060113181755.GO20718@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
>>diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
>>index b9d2bb8..1261a4f 100644
>>--- a/drivers/scsi/Makefile
>>+++ b/drivers/scsi/Makefile
>>@@ -164,6 +164,7 @@ CFLAGS_ncr53c8xx.o	:= $(ncr53c8xx-flags-
>> zalon7xx-objs	:= zalon.o ncr53c8xx.o
>> NCR_Q720_mod-objs	:= NCR_Q720.o ncr53c8xx.o
>> libata-objs	:= libata-core.o libata-scsi.o
>>+scsi_transport_iscsi-objs := libiscsi.o iscsi_if.o
> 
> 
> Please keep the interface file as scsi_transport_iscsi.c.  libiscsi should
> become a separate module and/or be linked with with iscsi_tcp.ko
> 

ok, I could actually make this more like libata and a normal transport 
class too. Let me respin this patch.
