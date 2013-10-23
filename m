From: Junliang Li <lijunliang.dna@gmail.com>
Subject: SCSI error handle trace
Date: Wed, 23 Oct 2013 15:01:47 +0800
Message-ID: <1382511707.2348.36.camel@ljl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46158 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3JWHB5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2013 03:01:57 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz1so564579pad.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2013 00:01:57 -0700 (PDT)
Received: from [192.168.20.26] ([119.39.124.239])
        by mx.google.com with ESMTPSA id oj6sm38724545pab.9.2013.10.23.00.01.54
        for <linux-scsi@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Wed, 23 Oct 2013 00:01:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi, all

Recently, fnic driver patches a feature that gathers various important
stats for debugging issues. Sysadm can find problems via this trace
utility, but just for fnic driver. 
In Linux SCSI subsystem, only a few trace points are set and we can not
trace deeply while middle layer handles error. AFAIK,
scsi_dispatch_cmd_error is available for running command error in LLD,
but how about Fibre Channel error or something like that?  
A RAS tool named rasdaemon can use trace info to record errors. Now it
supports cpu, memory and PCIe error recording. If SCSI subsystem exports
more trace points, I think we can support SCSI error recording in
rasdaemon.

Best regards,
Junliang Li

