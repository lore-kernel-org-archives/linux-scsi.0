From: Bharata B Rao <bharata@in.ibm.com>
Subject: [BUG] Fusion MPT Base Driver initialization failure with kdump
Date: Tue, 12 Jul 2005 11:26:49 +0530
Message-ID: <1121147809.10622.9.camel@localhost.localdomain>
Reply-To: bharata@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262388AbVGLF6v@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fusion MPT base driver fails during initialization when kdump capture
kernel boots. The details of the problem are reported here:

http://bugzilla.kernel.org/show_bug.cgi?id=4870

Regards,
Bharata.
