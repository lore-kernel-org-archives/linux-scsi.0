From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH 17/18] lpfc 8.3.42: Fixed issue of task management commands
 having a fixed timeout
Date: Mon, 9 Sep 2013 09:43:08 -0500
Message-ID: <522DDE7C.1020008@tributary.com>
References: <1378484566.14051.36.camel@myfc17> <522A2125.9040406@tributary.com> <522C82DF.2000305@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.51]:16490 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3IIOnO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2013 10:43:14 -0400
In-Reply-To: <522C82DF.2000305@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "james.smart@emulex.com" <james.smart@emulex.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 9/8/2013 8:59 AM, James Smart wrote:

> The other issue - we seem to have missed your prior post. I'll look into it
> shortly.


Thanks,

	Those patches were the result of various error injection test cases we were
performing. The ones that come to mind were, hung sequences, TM rejects,
failures to respond to the TM, etc.








