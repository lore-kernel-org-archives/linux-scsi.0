From: David Howells <dhowells@redhat.com>
Subject: Symbol conflict in QLA drivers
Date: Thu, 05 Oct 2006 14:41:41 +0100
Message-ID: <29174.1160055701@warthog.cambridge.redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54942 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1750860AbWJENly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2006 09:41:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com
Cc: linux-scsi@vger.kernel.org, dhowells@redhat.com


Two different QLA drivers (qla2xxx and qla4xxx) both define a variable called:

	extended_error_logging

This results in a namespace conflict when both drivers are compiled in (make
allyesconfig for example).

David
