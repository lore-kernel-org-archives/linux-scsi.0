From: Tom Yan <tom.ty89@gmail.com>
Subject: [PATCH 1/2] sd: Sanity check the optimal I/O size
Date: Fri, 26 Jun 2015 20:58:23 +0800
Message-ID: <CAGnHSEmAG94Hc4ikJPd2eQEkB-M6PUL0Ks+yg0W8gwLqx8cq=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:35563 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbbFZM6Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2015 08:58:25 -0400
Received: by qgeu36 with SMTP id u36so34743837qge.2
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2015 05:58:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Would it be better to only report when the value is smaller than
256MiB instead of "capping" it?
