From: "Aleks Sheynkman" <aleks@Narus.com>
Subject: executing ioctl 0x80 megaraid2-2.10.7
Date: Tue, 31 Aug 2004 14:58:50 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <FA6D803197D0E14C88E1B74C5A021B822DDF81@snitch.narus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Greetings,
  In the past was using my utility to get status information from the megaraid device using ioctl 0x80. 
When I installed a new driver megaraid2-2.10.7 and try to execute same ioctl, I started to get kernel panics. I'm using AS 2.1 with kernel 2.4.9-e.49smp . I'm kind of stumble because 2-2.10.7 suppose to convert old ioctl to the new format and feel up all needed address.

Did anyone ran into this problem before ?

Thank you very much in advance !

Aleks
