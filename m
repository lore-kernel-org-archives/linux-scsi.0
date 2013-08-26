From: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
Subject: [PATCH 1/3] arcmsr: Support Areca new SATA Raid Adapter ARC1214/1224/1264/1284
Date: Mon, 26 Aug 2013 12:12:19 +0800
Message-ID: <12D837ECDEC84883A6B388BBA1B21E72@chingDT>
Reply-To: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55970 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3HZEMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 00:12:10 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl13so2926179pab.34
        for <linux-scsi@vger.kernel.org>; Sun, 25 Aug 2013 21:12:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: billion@areca.com.tw

From: Ching <ching2048@areca.com.tw>


Support Areca new SATA Raid adapter ARC1214/1224/1264/1284.
Modify maximum outstanding command number, notify command complete with auto 
request sense
Signed-off-by: Ching  <ching2048@areca.com.tw>

