From: Luben Tuikov <ltuikov@yahoo.com>
Subject: UASP: updates and merges
Date: Tue, 8 Mar 2011 23:35:00 -0800 (PST)
Message-ID: <794860.74593.qm@web31816.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org

I've merged Linux 2.6.38-rc8. The UASP driver saw the following update:

[USB] UASP: Process INVALID INFORMATION UNIT response

A UAS Target Port responds with a RESPONSE IU with
RESPONSE CODE set to INVALID INFORMATION UNIT,
when it receives an IU with IU ID set to a
reserved value.  Handle this response.

The branch can be found here off of master:
https://github.com/ltuikov/linux-2.6

Original posting of the UASP driver can be found here:
http://marc.info/?l=linux-usb&m=129165511732388&w=2

    Luben
