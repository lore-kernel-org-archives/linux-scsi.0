From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: scsi traffic sniffing
Date: Tue, 1 Sep 2009 19:13:48 +0200
Message-ID: <e2e108260909011013v72988aa4ged4d1841767883a6@mail.gmail.com>
References: <48e952f40908312312w7765c2a1q3a4f022967735288@mail.gmail.com>
	 <48e952f40908312313u75e4d00cr3d934f1dbdd1cca9@mail.gmail.com>
	 <48e952f40908312313y372d5009mc0197dff49d3b778@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:38534 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZIARNr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 13:13:47 -0400
Received: by ewy2 with SMTP id 2so128835ewy.17
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2009 10:13:48 -0700 (PDT)
In-Reply-To: <48e952f40908312313y372d5009mc0197dff49d3b778@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Nell <crtrn13@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 1, 2009 at 8:13 AM, Jonathan Nell <crtrn13@gmail.com> wrote:
> Is there any way to sniff the traffic of a scsi device? I need to
> debug a firmware update and need to see the traffic being passed to
> the drive

One possible approach is to access the device via iSCSI and to capture
the iSCSI traffic with a network analyzer, e.g. Wireshark. You will
have to install and configure iSCSI target software before you can do
this.

Bart.
