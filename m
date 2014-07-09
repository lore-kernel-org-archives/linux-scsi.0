From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Date: Wed, 9 Jul 2014 01:44:15 -0700
Message-ID: <20140709084415.GF6012@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-6-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1404866812-26950-6-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org, jasowang@redhat.com, linux-kernel@vger.kernel.org, jbottomley@parallels.com, ohering@suse.com, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 08, 2014 at 05:46:50PM -0700, K. Y. Srinivasan wrote:
> Implement a simple abort handler. The host does not support "Abort"; just
> ensure that all inflight I/Os have been accounted for.

The abort handler should abort a single command, not wait for all of
them.  What issue do you see that this tries to address?
