From: James.Smart@Emulex.Com
Subject: RE: [PATCH] SAS transport class
Date: Tue, 6 Sep 2005 10:24:51 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F453A@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:9190 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S964849AbVIFOZF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Sep 2005 10:25:05 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: linux-scsi@vger.kernel.org

> > So this is odd... grandparent ?  why pass in port # (you should
> > know the object already)?  why is channel skipping over / not
> > associated with the local port ?
> 
> I didn't really want to need the drivers to keep around arrays
> or lists of sas_port objects.

They're going to have to if they ever need to call xxx_delete() (or
perhaps block functions, etc)... which is all likely once the mgmt
interface is in place, or you start dealing with run-time events.

Everything else sounds good...

-- james s

 
