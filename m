From: Andries.Brouwer@cwi.nl
Subject: Re: IDs
Date: Tue, 7 Jan 2003 11:55:00 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200301071055.h07At0T09202.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, patmans@us.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-kernel@one-eyed-alien.net, zwane@holomorphy.com

> But, we don't have to truncate, we should just allocate as many bytes as
> we need, and store the information.

> And, the sysfs name should not store the id.

OK. It seems that we are in total agreement.
Time for the next question.

An id is constructed, that in many cases identifies something.
How do you plan to use this? Is it already in use somewhere?

The sysfs tree does not contain device nodes.
Do you plan a user space utility that figures out that
the ID "SHP      CD-Writer+ 8200 [" belongs to /dev/hdd
which also is /dev/sr0?

The id is not suitable as a user space name. Moreover,
it is a heuristic only, and user space needs unambiguous names.
What user space names do you want to use?

Andries
