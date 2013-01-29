From: Lee Duncan <lduncan@suse.com>
Subject: [LSF/MM TOPIC] Making sure soft SCSI Targets are Valid
Date: Tue, 29 Jan 2013 11:13:44 -0800
Message-ID: <51081F68.1030808@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:47706 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab3A2TNx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2013 14:13:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: linux-scsi@vger.kernel.org, ronnie sahlberg <ronniesahlberg@gmail.com>

Hi:

I'm not sure if there is much interest in this, but I've recently
realized that there is no good free software to validate iSCSI targets,
not to mention FCOE targets, IB soft targets, etc. There's just no way
to know if any change you make is "legal" short of learning to speak
SCSI geek spec (or waiting to see what fails when you make a subtle change).

So I have been working with the (user-space) libiscsi creator and
maintainer, Ronnie Sahlberg, to enhance his test suite. But this only
addresses iSCSI targets. Some of his tests have already shown problems
like kernel panics when an incorrect bit is injected, showing the need
for such testing.

It occurs to me it would be most valuable if we had more generic SCSI
tests, not even limited to soft targets, available to developers and
manufacturers. How best to support such tests with our SCSI layer, and
what tests are needed now and in the future may be a good topic for
discussion.
-- 
Lee Duncan
SUSE Labs
