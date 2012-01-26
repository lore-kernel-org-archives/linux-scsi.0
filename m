From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [LSF/MM TOPIC][ATTEND] linux servers as a storage server - what's missing?
Date: Thu, 26 Jan 2012 12:15:59 +0100
Message-ID: <CAO+b5-oH8Q4jq737nqQ4BmvM8+4v8rxJCkpjX2ZkiDVa8SG5GQ@mail.gmail.com>
References: <4EF2026F.2090506@redhat.com>
	<20120103142609.2b4d06cb@tlielax.poochiereds.net>
	<20120124213609.GA12426@fieldses.org>
	<4F1F3B00.8060603@redhat.com>
	<4F206543.60309@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41453 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2AZLQB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jan 2012 06:16:01 -0500
In-Reply-To: <4F206543.60309@samba.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Christopher R. Hertel" <crh@samba.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jeremy Allison <jra@samba.org>, Simo Sorce <simo@redhat.com>

On Wed, Jan 25, 2012 at 9:25 PM, Christopher R. Hertel <crh@samba.org> wrote:
> Where are we on FCoE support?

Initiator and target mode should work, except that VN2VN mode is
broken. See also
http://lists.open-fcoe.org/pipermail/devel/2011-December/011892.html.

Bart.
