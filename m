From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Fix COMPARE_AND_WRITE with SG_TO_MEM_NOALLOC
 handling
Date: Wed, 08 Apr 2015 11:34:53 -0700
Message-ID: <1428518093.15139.1.camel@haakon3.risingtidesystems.com>
References: <1428449682-387-1-git-send-email-nab@daterainc.com>
	 <20150408163331.GA3447@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150408163331.GA3447@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-04-08 at 18:33 +0200, Christoph Hellwig wrote:
> This fixes the crash that I saw, but the Compare and Write testcast
> in the scsi testsuite still fails..

I'm not seeing this on my end:

root@scsi-mq:/usr/src/libiscsi.git# ./test-tool/iscsi-test-cu --test LINUX.CompareAndWrite /dev/sg0 --dataloss
    [SKIPPED] REPORT_SUPPORTED_OPCODES is not implemented.



     CUnit - A Unit testing framework for C - Version 2.1-0
     http://cunit.sourceforge.net/


Suite: CompareAndWrite
  Test: Simple ... passed
  Test: DpoFua ...     [SKIPPED] REPORT_SUPPORTED_OPCODES is not implemented.
    REPORT_SUPPORTED_OPCODES not implemented. Skipping this part of the test
passed
  Test: Miscompare ... passed

--Run Summary: Type      Total     Ran  Passed  Failed
               suites        1       1     n/a       0
               tests         3       3       3       0
               asserts    2048    2048    2048       0
Tests completed with return value: 0
