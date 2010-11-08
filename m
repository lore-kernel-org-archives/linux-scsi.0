From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv3 10/21] tcm: Add SPC-4 compliant Persistent Reservations
 (PR)
Date: Mon, 8 Nov 2010 09:50:54 -0500
Message-ID: <20101108145054.GA1295@infradead.org>
References: <1287441467-19915-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1287441467-19915-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Gcc on 32-bit x86 doesn't seem too happy about the stack usage here:

drivers/target/target_core_pr.c: In function '__core_scsi3_update_aptpl_buf':
drivers/target/target_core_pr.c:1955: warning: the frame size of 1116 bytes is larger than 1024 bytes
