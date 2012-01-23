From: Tony Asleson <tasleson@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] Storage management (API & Library)
Date: Mon, 23 Jan 2012 08:47:21 -0600
Message-ID: <4F1D72F9.8000409@redhat.com>
References: <4F19A981.4080502@redhat.com> <CABE8wwvK=uQx2cTK44Sn+79dj+MyGM1y4n7MoounkR7STHFkXQ@mail.gmail.com>
Reply-To: tasleson@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab2AWOrY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2012 09:47:24 -0500
In-Reply-To: <CABE8wwvK=uQx2cTK44Sn+79dj+MyGM1y4n7MoounkR7STHFkXQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On 01/20/2012 05:28 PM, Dan Williams wrote:
> Interesting, how does this relate, or not relate, to udisks in device-kit?

The initial focus for libStorageMgmt is on managing external block level
storage arrays (LUN creation, deletion, re-sizing, replication and
mapping/un-mapping storage to initiators).  Once the logical unit is
available for the system, other libraries/tools will take over to get
the storage ready for use (Partitioning, FS creation etc.).

One could envision udisks as being a user of libStorageMgmt.  To
dynamically add/remove storage devices to a system and to leverage the
operations that can be completed on the array hardware vs. local system
(e.g. hardware array snapshot vs. lvm snapshot).

Regards,
Tony
