From: michaelc@cs.wisc.edu
Subject: lpfc fixes for 2.6.39
Date: Fri, 25 Feb 2011 14:04:26 -0600
Message-ID: <1298664268-12967-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920Ab1BYUEc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 15:04:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.smart@emulex.com

The following 2 patches were made over scsi-misc. They fix
one bug where the retries on a command could get used during
the port transition race. And they fix a issue where
we were blocking the entire host when just one port affected
by a overqueueing problem.

