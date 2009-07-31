From: Madhukar G <madhukar.linux@gmail.com>
Subject: Understanding SAS
Date: Fri, 31 Jul 2009 17:26:18 +0530
Message-ID: <e79524560907310456x7b2cf0c0h7e0453ceb55982fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:50539 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZGaL4S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2009 07:56:18 -0400
Received: by ywh13 with SMTP id 13so1633244ywh.15
        for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2009 04:56:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

I'm understanding SAS architecture for adaptec controller. I'm using
the source adp94xx for the same. I was able to understand all the
infomation unit flow but i'm stuck with one problem. I was not able to
trace when task management IU shall be invoked.
Do i need any special app to test task management IU?
Is SCSI layer responsible for invoking task management IU?

Thanks.
madhukar
