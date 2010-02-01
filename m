From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: [PATCH 0/2 v2] scsi: ftrace based scsi tracing feature
Date: Mon, 01 Feb 2010 13:55:37 +0900
Message-ID: <4B665EC9.6000608@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

This is v2 patch series of SCSI trace.

Changelog from v1:

 - fixed variable length command handling (DIF_TYPE2 case only)
 - moved scsi trace functions from kernel/trace/scsitrace.c to
   drivers/scsi/scsi_trace.c

Here are the links to the discussions on v1:

  [PATCH 0/2] scsi: ftrace based scsi tracing feature
    http://marc.info/?l=linux-scsi&m=126396981308416&w=2
  [PATCH 1/2] scsi: add __print_hex() to ftrace
    http://marc.info/?l=linux-scsi&m=126396984308451&w=2
  [PATCH 2/2] scsi: add scsi trace core function and put trace points
    http://marc.info/?l=linux-scsi&m=126396987608486&w=2

This patchset applies to 2.6.33-rc6.

Thanks,
Kei
