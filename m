From: Ewan Milne <emilne@redhat.com>
Subject: [LSF/MM ATTEND] [LSF/MM TOPIC]
Date: Fri, 09 Jan 2015 11:14:08 -0500
Message-ID: <1420820048.3891.156.camel@localhost.localdomain>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbbAIQOM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2015 11:14:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: linux-scsi@vger.kernel.org

I'd like to attend LSF -- I am responsible for maintaining the SCSI
subsystem at Red Hat, and in addition to resolving issues for customers
and partners, I've been participating in upstream development for the
past couple of years.  I have an extensive background in SCSI and OS
development, including 15 years of working with the Linux kernel.

I would also like to have a discussion at LSF/MM 2015 about how we could
better handle devices whose properties change after being probed. This
includes:

  - READ CAPACITY data
  - ALUA state
  - EMC OWNED/UNOWNED state
  - NOT READY state

Currently, when these properties change, we do not always handle it
very well (e.g. multipath stops using a path if the capacity changes,
even if it the only good path to the device...)

-Ewan Milne <emilne@redhat.com>


