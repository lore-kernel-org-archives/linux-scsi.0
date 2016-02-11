From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] target: Fix incorrect unmap_zeroes_data_store return
Date: Thu, 11 Feb 2016 13:30:40 +0200
Message-ID: <56BC70E0.1060505@dev.mellanox.co.il>
References: <1455174146-29700-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:34089 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbcBKLap (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2016 06:30:45 -0500
Received: by mail-wm0-f47.google.com with SMTP id 128so16930644wmz.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2016 03:30:44 -0800 (PST)
In-Reply-To: <1455174146-29700-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jamie Pocas <jamie.pocas@emc.com>, Nicholas Bellinger <nab@linux-iscsi.org>

Looks good,

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
