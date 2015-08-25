From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [ANNOUNCE] tapestat command now part of upstream sysstat
Date: Tue, 25 Aug 2015 00:37:11 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB44471B10@G9W0748.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:58801 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbbHYAic convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2015 20:38:32 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, Sebastien Godard <sysstat@orange.fr>


While tape stats were being implemented in the kernel I started working
on a program that would read them out and display the data to allow me
to test the interface. After the changes were available in linux-next
I worked with the upstream sysstat maintainer to get that code into shape
so it was suitable for inclusion into sysstat. The latest version of
sysstat on github now contains the tapestat command:

https://github.com/sysstat/sysstat

New tarballs will be available from the sysstat homepage soon. 

Some example output (this is the only format) while using the dd command
to copy a tape from a slow tape drive to a fast one (DDS to LTO):

Tape:    r/s     w/s   kB_read/s   kB_wrtn/s %Rd %Wr %Oa    Rs/s    Ot/s
st0        0     523           0        5230   0  14  14       0       0
st1      523       0        5230           0  83   0  83       0       0

Tape:    r/s     w/s   kB_read/s   kB_wrtn/s %Rd %Wr %Oa    Rs/s    Ot/s
st0        0     406           0        4060   0  11  11       0       0
st1      406       0        4060           0  86   0  86       0       0

Tape:    r/s     w/s   kB_read/s   kB_wrtn/s %Rd %Wr %Oa    Rs/s    Ot/s
st0        0     318           0        3181   0   8   8       0       0
st1      318       0        3182           0  90   0  90       0       0

I want to thank everyone who provided advice, feedback, or helped me get
tape stats to this point - especially Sebastien who was a pleasure to work
with.

Thanks
Shane
