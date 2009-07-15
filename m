From: =?UTF-8?B?6LCi57qy?= <xiegang112@gmail.com>
Subject: The return of the sense data
Date: Wed, 15 Jul 2009 14:01:45 +0800
Message-ID: <d364733c0907142301s29ec243eu34508aaf3ddad0a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:23537 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZGOGBp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2009 02:01:45 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1170011wfd.4
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2009 23:01:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm little confused about the time of returning the sense data.

After the status of the scsi response is check condition and sense
data is generated, When do we send the sense data? In the response
which contain the command status of check condition,  or send it when
received a REQUEST SENSE cmd?
-- 
Xie Gang
