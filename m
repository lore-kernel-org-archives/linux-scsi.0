From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [TRIVIAL] Re: Kernel patches...
Date: 06 Dec 2002 13:16:54 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1039180614.22971.4.camel@irongate.swansea.linux.org.uk>
References: <20021206035754.B2B912C256@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021206035754.B2B912C256@lists.samba.org>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Trivial Russell <rusty@rustcorp.com.au>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

  OK, so here is the new patch.
  It takes advantage of hdXlun, so no changes to the config files are
needed.
  By default keeps IDE LUN at zero, unless hdXlun=n specified on command
line.
  Compiles with 2.4.20.
 

Rejected

