From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: sg version 4 tools
Date: Thu, 15 Feb 2007 10:39:02 +0900 (JST)
Message-ID: <20070214153508Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:59377 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbXBOBjP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Feb 2007 20:39:15 -0500
Received: from mfs34.rdh.ecl.ntt.co.jp (mfs34.rdh.ecl.ntt.co.jp [129.60.39.114])
	by tama5.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id l1F1d7dF009973
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2007 10:39:07 +0900 (JST)
Received: from mfs34.rdh.ecl.ntt.co.jp (localhost [127.0.0.1])
	by mfs34.rdh.ecl.ntt.co.jp (Postfix) with ESMTP id 5AD9E20AE2A
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2007 10:39:07 +0900 (JST)
Received: from nttmail3.ecl.ntt.co.jp (nttmail3.ecl.ntt.co.jp [129.60.39.100])
	by mfs34.rdh.ecl.ntt.co.jp (Postfix) with ESMTP id 26D0F20AE2B
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2007 10:39:07 +0900 (JST)
Received: from dmailsv1.y.ecl.ntt.co.jp (dmailsv1.y.ecl.ntt.co.jp [129.60.53.14])
	by nttmail3.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id l1F1d6aI021547
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2007 10:39:06 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I created a git tree for makeshift sg version 4 tools:

http://www.kernel.org/git/?p=linux/kernel/git/tomo/sgv4-tools.git;a=summary

# not synchronized yet.

The interface has changed continuously (and will do). After mainline
inclusion, Doug's sg tools support sg v4, I think. Until then, I put
tools that I use for sg v4 development.

Currently, there is only one tool, sgv4_dd, which can read/write
from/to a device via the bsg interface (both ioctl and the read/write
interfaces are supported).

Here are some examples:

# ./sgv4_dd -i /dev/sdb -o /dev/null --count 2
succeeded (read/write interface)

# ./sgv4_dd -i /dev/sdb -o /dev/null --count 2 --sgio
succeeded (SG_IO)

# ./sgv4_dd -i /dev/zero -o /dev/sdb --count 3 --sgio
succeeded (SG_IO)

# ./sgv4_dd -i /dev/zero -o /dev/sdb --count 3
succeeded (read/write interface)
