From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] scsi: scsi_transport_fc: Provide a lightweight
 option for Virtual FC Hosts.
Date: Thu, 19 Jan 2017 07:11:55 -0800
Message-ID: <20170119151155.GA28462@infradead.org>
References: <1484771338-8903-1-git-send-email-cavery@redhat.com>
 <1484771338-8903-2-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1484771338-8903-2-git-send-email-cavery@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Cathy Avery <cavery@redhat.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 18, 2017 at 03:28:57PM -0500, Cathy Avery wrote:
> The patch provides a means to offer a lightweight option to the
> current FC transport class. The new option is selected by a
> driver when it indicates it wants the lightweight
> transport via fc_function_template.

This need some really good documentation in the code and changelog
what "lightweight" means.  It's a pretty horrible term, btw.
