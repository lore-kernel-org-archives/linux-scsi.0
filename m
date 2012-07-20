From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: question about  path_id of scsi hard disk
Date: Fri, 20 Jul 2012 23:31:54 +0100
Message-ID: <1342823514.2984.48.camel@dabdike.int.hansenpartnership.com>
References: <op.whqka8y2n27o5l@gaoqiang-d1.corp.qihoo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49258 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173Ab2GTWb6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jul 2012 18:31:58 -0400
In-Reply-To: <op.whqka8y2n27o5l@gaoqiang-d1.corp.qihoo.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gaoqiang <gaoqiangscut@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2012-07-20 at 16:24 +0800, gaoqiang wrote:
> I'm using udev to manage my hard disks. but I'm confusing
> about the "PATH_ID"
> 
> gaoqiang@h150:~$/lib/udev/path_id  /block/sda
> ID_PATH=pci-0000:01:00.0-scsi-0:0:0:0
> 
> the path_id is about disk or about disk slot ?

Neither: it's pci function and scsi host:channel:target:lun

As far as I can tell, path_id returns are completely useless for
labelling disks (since host and sometimes target are scan order
dependent).

James


