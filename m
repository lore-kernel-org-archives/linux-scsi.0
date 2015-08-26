From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 3/3] megaraid_sas : fix whitespace errors
Date: Wed, 26 Aug 2015 07:36:30 -0700
Message-ID: <1440599790.2196.9.camel@HansenPartnership.com>
References: <20150707204916.6218.37871.stgit@bhelgaas-glaptop2.roam.corp.google.com>
	 <20150707205245.6218.59809.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150707205245.6218.59809.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-07-07 at 15:52 -0500, Bjorn Helgaas wrote:
> Fix whitespace and indentation errors.  No code change.

checkpatch says you missed one:

ERROR: space required after that ',' (ctx:VxV)
#860: FILE: drivers/scsi/megaraid/megaraid_sas_base.c:6457:
+       if (sscanf(buf,"%u",&megasas_dbg_lvl) < 1) {
                      ^

ERROR: space required after that ',' (ctx:VxO)
#860: FILE: drivers/scsi/megaraid/megaraid_sas_base.c:6457:
+       if (sscanf(buf,"%u",&megasas_dbg_lvl) < 1) {
                           ^

ERROR: space required before that '&' (ctx:OxV)
#860: FILE: drivers/scsi/megaraid/megaraid_sas_base.c:6457:
+       if (sscanf(buf,"%u",&megasas_dbg_lvl) < 1) {


I fixed it up

James
