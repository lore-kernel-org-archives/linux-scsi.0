From: Tony Asleson <tasleson@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] Storage management (API & Library)
Date: Mon, 23 Jan 2012 10:21:39 -0600
Message-ID: <4F1D8913.1060709@redhat.com>
References: <4F19A981.4080502@redhat.com> <1327157825.2748.5.camel@dabdike.int.hansenpartnership.com>
Reply-To: tasleson@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab2AWQVm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2012 11:21:42 -0500
In-Reply-To: <1327157825.2748.5.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On 01/21/2012 08:57 AM, James Bottomley wrote:
> It's also a bit insular ... the first thing you usually ask in open
> source is what can I steal^Wborrow from other projects and how do I
> recruit others to do the work for me.

The project site is a little sparse on details about what we have looked
at and considered.  Ric Wheeler covered some of this during his
presentation in Prague, but I will place more information on the project
web site.

> The first question is probably: is there anything we can liberate
> from the Oracle storage API fisasco to help with this.

The Oracle storage connect library was evaluated and subsequently
rejected for the following reasons:

1. The Oracle storage connect library is dual licensed, GPL and a
proprietary Oracle license which allows proprietary use.  This allows
hardware vendors the ability to write proprietary plug-ins.  The design
of the library has the library user and plug-in executing in the same
address space.  Based on the information presented on plug-ins
(http://www.gnu.org/licenses/gpl-faq.html#GPLAndPlugins) this design
goes against the requirements of GPL license compliance.  Proprietary
plug-ins could be in compliance if they are implemented to execute in a
separate process.

2. At the time the Oracle storage connect library was being evaluated we
were unable to obtain a plug-in from a few different vendors.  Without
plug-ins the value of any library becomes greatly diminished.

> The second might be what would it take to get vendors interested in
> doing the array plugin glue.

By providing:
* Permissive license (LGPL)
* Easy to use out of process plug-in support to allow proprietary
plug-ins (IPC is abstracted)
* Language agnostic plug-in support (initial support is C and python)

We are hoping we can get hardware vendors interested in providing their
own plug-ins.  If anyone has additional ideas, we would certainly like
to discuss them.

Regards,
Tony
