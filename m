From: Bill Adair <adair@gotadsl.co.uk>
Subject: Forcing use of sd driver on Suse 10.3 (2.6.22)
Date: Mon, 14 Jan 2008 11:01:54 +0000
Message-ID: <1200308514.4729.25.camel@desk.ty-rhos-barn>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:29909
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100AbYANLLf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 06:11:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a device reported as below. It is a PCMCIA card reader with
SCSI-2 connections. I know the device can work as a direct access device
when flash memory is present as I have connected it to an Akai sampler
which can read the card. I am assuming here the sampler's SCSI stack is
not very complex and is just ignoring the device type.

[2:0:6:0]    process MPL      MC-DISK-E[0]     3.9a  -         /dev/sg2
[2:0:6:1]    process MPL      MC-DISK-E[0]     3.9a  -         /dev/sg3
[2:0:6:2]    process MPL      MC-DISK-E[0]     3.9a  -         /dev/sg4
[2:0:6:3]    process MPL      MC-DISK-E[1]     3.9a  -         /dev/sg5
[2:0:6:4]    process MPL      MC-DISK-E[1]     3.9a  -         /dev/sg6
[2:0:6:5]    process MPL      MC-DISK-E[1]     3.9a  -         /dev/sg7
[2:0:6:6]    process MPL      MC-DISK-E[0]     3.9a  -         /dev/sg8
[2:0:6:7]    process MPL      MC-DISK-E[0]     3.9a  -         /dev/sg9

Is there any way under Linux of forcing use of the sd driver for a
device on the bus instead of sg?

TIA 
Bill

