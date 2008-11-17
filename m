From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Enterprise workload testing for storage and filesystems
Date: Tue, 18 Nov 2008 07:47:42 +0900
Message-ID: <1226962063.3403.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "K.S. Bhaskar" <ks.bhaskar@fnis.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,

High on our list at the recent Linux Foundation end user summit was
obtaining a method of obtaining enterprise workloads (or simulators) we
can run in our own testing environments.  The main problem being that
the data sets used by the systems are usually secret or under regulatory
embargo and thus unobtainable.  However, several participants noted that
regulatory prohibitions also extended to their own in-house IT team,
thus they had had to develop simulators for the workloads which, since
they contained no customer data, might be more widely distributable.

Fidelity National Information Service were the first to try this.
They've kicked off a sourceforge site for their stress testing tool
(which is the same tool they use in their own qualification labs).  The
source for the tool is available here:

http://sourceforge.net/project/showfiles.php?group_id=11026&package_id=298597

And it comes with a fairly detailed readme explaining what it's trying
to simulate and why.  Hopefully this will give us all a much better
insight into both enterprise workloads and the way enterprise IT
departments conduct testing.

Let's see how our storage and filesystem tuning measures up to this.

James


