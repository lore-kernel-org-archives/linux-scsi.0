From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target fixes for v4.11-rc3
Date: Sat, 18 Mar 2017 21:01:43 -0700
Message-ID: <1489896103.8236.10.camel@haakon3.risingtidesystems.com>
References: <1489889280.27336.80.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39726 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbdCSECS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Mar 2017 00:02:18 -0400
In-Reply-To: <1489889280.27336.80.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Sat, 2017-03-18 at 19:08 -0700, Nicholas A. Bellinger wrote:
> Hello Linus,
> 
> Here are the target-pending fixes for v4.11-rc3 code.  Please go ahead
> and pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master
> 
> The bulk of the changes are in qla2xxx target driver code to address
> various issues found during Cavium/QLogic's internal testing (stable
> CC's included), along with a few other stability and smaller
> miscellaneous improvements.

Wrt the other qla2xxx improvements in this PULL request..

They where originally intended for v4.11-rc1, but missed the merge
window due to a regression reported on the list.

Since then, they have gone through 4 revisions over the last 7 weeks,
and Cavium/QLogic folks have addressed the outstanding regression +
feedback, and this series has passed their internal Q/A testing.

So while I acknowledge they aren't all strictly bug-fixes (5 of them are
CC'ed for stable), all are self contained within qla2xxx and I do trust
the Cavium/QLogic team's sign-off for the complete series.

Please consider pulling the series.
