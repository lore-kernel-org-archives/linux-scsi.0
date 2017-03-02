From: Fam Zheng <famz@redhat.com>
Subject: Re: sg driver, sg_io and sg tablesize
Date: Thu, 2 Mar 2017 19:41:39 +0800
Message-ID: <20170302114139.GA22977@lemon.lan>
References: <791707934.40662785.1488383072891.JavaMail.zimbra@redhat.com>
 <50601133.40845997.1488406291147.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752068AbdCBLuk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Mar 2017 06:50:40 -0500
Content-Disposition: inline
In-Reply-To: <50601133.40845997.1488406291147.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: dgilbert@interlog.com, Linux SCSI List <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>

On Wed, 03/01 17:11, Laurence Oberman wrote:
> This was suggested by Ewan and is the best way to know what the actual max I/O
> size for sg_io would be for the LPFC driver.

This sounds silly, why is there a "lame" max I/O size as in max_sectors_kb,
that is unusable because of a more limiting max_segments, and an "actual max
I/O size" as derived from the latter? What is the reason of the contradiction
here?

Fam
