From: rct@gherkin.frus.com (Bob Tracy)
Subject: Re: class_device_add error in SCSI with 2.6.17-rc2-g52824b6b
Date: Wed, 19 Apr 2006 16:58:03 -0500 (CDT)
Message-ID: <20060419215803.6DE5BDBA1@gherkin.frus.com>
References: <20060419213129.GA9148@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:27912 "EHLO gherkin.frus.com")
	by vger.kernel.org with ESMTP id S1751265AbWDSV6F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 17:58:05 -0400
In-Reply-To: <20060419213129.GA9148@localhost> "from Mathieu Chouquet-Stringer
 at Apr 19, 2006 11:31:29 pm"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mathieu Chouquet-Stringer <mchouque@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Mathieu Chouquet-Stringer wrote:
> While booting 2.6.17-rc2-g52824b6b on an alpha (a 164LX clone), I get
> the following error messages for every sd devices that get registered:
> 
> sd 0:0:0:0: Attached scsi disk sda
> kobject_add failed for 0:0: with -EEXIST, don't try to register things with the same name in the same directory.

Similar error previously reported by me for 2.6.17-rc1, except sda got
added fine: error occurred when attempting to add/register sdb. 
Thankfully, you were able to append a trace...

I'll be trying the just-released 2.6.17-rc2 this evening.  Report to
follow, and if there's a problem, I'll attempt to provide the trace
(will have to be transcribed by hand, as system won't come up far
enough for syslog to capture anything).

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
