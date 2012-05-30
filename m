From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2] scsi: fix async probe regression
Date: Wed, 30 May 2012 16:00:43 -0700
Message-ID: <CAA9_cmfPXrx-DAA2oSH+ZvrLTvZsT8g0O3jNMT5ZnA8Z_GWTMA@mail.gmail.com>
References: <20120525175140.22423.21697.stgit@dwillia2-linux.jf.intel.com>
	<jq3r1h$p37$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52627 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2E3XAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2012 19:00:44 -0400
In-Reply-To: <jq3r1h$p37$1@dough.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walt <w41ter@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, May 29, 2012 at 5:53 PM, walt <w41ter@gmail.com> wrote:
> On 05/25/2012 10:55 AM, Dan Williams wrote:
>> Commit a7a20d1 "[SCSI] sd: limit the scope of the async probe domain=
"
>> moved sd probe work out of reach of wait_for_device_probe(). =A0Allo=
w it
>> to be synced via scsi_complete_async_scans().
>
> Hi Dan. =A0After applying version 2 of a7a20d1 I can boot again, but =
there's
> a catch :)

Ah you took me off the cc, so I missed this originally.

>
> My grub.cfg boot menu entry uses the root=3DPARTUUID=3D<guid> syntax,=
 but that
> has stopped working. =A0After a7a20d1(v2) I have to use root=3D/dev/s=
da5 or I
> get the familiar "can't find block device (foo,bar)" kernel panic.

What is a7a20d1(v2)?  That's the original commit that broke things, so
I'm confused.

> Any idea what would cause that particular kind of breakage?

The fix should be equivalent for both root=3D options because if the
device can be found by /dev/sda5 I don't see anything related to the
async subsystem that would prevent it from being looked up by uuid??

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
