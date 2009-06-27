From: "wenshuang.ma" <wenshuang.ma@gmail.com>
Subject: Can LSISAS1068E chip be configured as a x8 wide port?
Date: Sat, 27 Jun 2009 18:59:30 +0800
Message-ID: <200906271859275463726@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:16131 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZF0K7b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2009 06:59:31 -0400
Received: by rv-out-0506.google.com with SMTP id f6so821339rvb.1
        for <linux-scsi@vger.kernel.org>; Sat, 27 Jun 2009 03:59:34 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric <Eric.Moore@lsil.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hi,

LSISAS1068E is a 2 ports(total 8 PHY) SAS controller with per port can be 
configured as a 4 PHY SAS wide port,with the usage of arbitrary one
port LSISAS1068E can control a SAS expander through a MiniSASx4 to 
SASx4 cable,we get 4 connections simultaneously.Is it possible for 
LSISAS1068E to control one SAS expander through two MiniSASx4 to SASx4
cables so we can have 8 connections simultaneously(more bandwidth)
if not,why? 

Thanks
Wenshuang
 				


